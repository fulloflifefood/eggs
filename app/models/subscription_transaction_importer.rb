class SubscriptionTransactionImporter

  def generate_transactions!(deliveries, perform=false)
    count = 0
    puts "perform: #{perform}"
    deliveries.each do |delivery|
      next if delivery.status != "archived"
      delivery.orders.each do |order|
        order.order_items.each do |item|
          if item.stock_item.product
            if item.stock_item.product.subscribable == true && item.quantity > 0
              if order.member.account_for_farm(delivery.farm).subscriptions.size == 1
                subscription = order.member.account_for_farm(delivery.farm).subscriptions.first

                trans = SubscriptionTransaction.new
                trans.date = delivery.date
                trans.description = "CSA Pickup: #{delivery.name} #{delivery.pretty_date}"
                trans.amount = item.quantity
                trans.debit = true
                trans.subscription_id = subscription.id
                trans.order_id = order.id
                count = count + 1
                if perform
                  trans.save!
                else
                  puts "---"
                  puts item.stock_item.product_name
                  puts order.member.last_name
                  puts trans.date
                  puts trans.amount
                  puts trans.description
                end
              end
            end
          end
        end
      end
    end
    puts "Total Count: #{count}"
    return count
  end

  def output_mismatches(deliveries)

    deliveries.each do |delivery|
      delivery.orders.each do |order|
        order.order_items.each do |item|
          if item.stock_item.product
            if item.stock_item.product.subscribable && item.quantity > 0
              if order.member.account_for_farm(delivery.farm).subscriptions.size != 1
                puts "member does not have subscription:"
                puts order.member.last_name
                puts order.id
              end
            end
          end
        end
      end
    end
  end

end