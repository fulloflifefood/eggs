class DeliveryStatusManager

  def self.update_statuses
    self.get_deliveries_by_status('finalized').each do |delivery|
      if delivery.date < Time.current.to_date
        delivery.update_attribute('status', 'archived')
      end
    end

    self.get_deliveries_by_status('open').each do |delivery|
      if(delivery.closing_at < Time.current)
        delivery.update_attribute('status', 'inprogress')
      end
    end

    self.get_deliveries_by_status('notyetopen').each do |delivery|
      if(delivery.opening_at < Time.current)
        delivery.update_attribute('status', 'open')
      end
    end

    self.get_deliveries_by_status('inprogress').each do |delivery|
      if(delivery.finalized_totals && delivery.deductions_complete)
        delivery.update_attribute('status', 'finalized')
      end
    end
  end
  
  def self.get_deliveries_by_status(status)
    Delivery.find_all_by_status_and_status_override(status, false)
  end

end