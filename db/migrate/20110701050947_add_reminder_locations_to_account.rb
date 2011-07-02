class AddReminderLocationsToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :reminder_locations, :string
  end

  def self.down
    remove_column :accounts, :reminder_locations
  end
end
