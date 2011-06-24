class ReminderManager

  def schedule_reminders_for_delivery(delivery)

    return if (delivery.farm.reminders_enabled == false)

    last_call_email = EmailTemplate.find_by_farm_id_and_identifier(delivery.farm.id, "order_reminder_last_call")
    reminder_email = EmailTemplate.find_by_farm_id_and_identifier(delivery.farm.id, "order_reminder")


    datetime = date_to_time_with_zone(delivery.date, 7, 0, 0)

    last_call_datetime = datetime.advance :days => -6
    reminder_datetime  = datetime.advance :days => -14
    
    DeliveryOrderReminder.create!(:delivery_id => delivery.id,
                                  :email_template_id => last_call_email.id,
                                  :deliver_at => last_call_datetime)

    DeliveryOrderReminder.create!(:delivery_id => delivery.id,
                                  :email_template_id => reminder_email.id,
                                  :deliver_at => reminder_datetime)
            
  end

  def delete_reminders_for_delivery(delivery)
    reminders = DeliveryOrderReminder.find_all_by_delivery_id(delivery.id)
    reminders.each do |reminder|
      reminder.delete
    end
  end

  def get_ready_reminders
    # ready means deliver_at time is between created on and now

    reminders = DeliveryOrderReminder.find(
            :all,
            :conditions => ["deliver_at BETWEEN ? and ?", Time.current.utc - 20.days, Time.current.utc]
    )

    return reminders

  end

  def deliver_ready_reminders
    reminders = self.get_ready_reminders

    reminders.each do |reminder|
      template = EmailTemplate.find(reminder.email_template_id)

      members = self.get_email_eligible_members(reminder.delivery)

      members.each do |member|
        template.deliver_to(member.email_address, :delivery => reminder.delivery)
      end

      Notifier.admin_notify_reminders_sent(reminder.delivery, template).deliver

      reminder.delete
      
    end
    
  end

  def get_email_eligible_members(delivery)

    members = delivery.farm.members

    return [Member.find_by_email_address('kathryn@kathrynaaker.com')] if Rails.env == 'development'


    members.reject do |member|
      # reject if this member has an order for that delivery or is inactive
      has_order = false
      member.orders.each do |order|
        if(order.delivery == delivery)
          has_order = true
          break
        end
      end
      has_order || member.account_for_farm(delivery.farm).is_inactive?
    end
  end

  private

  def date_to_time_with_zone(date, hour = 0, min = 0, sec = 0)
    Time.zone.local(date.year, date.month, date.day, hour, min, sec)
  end

end