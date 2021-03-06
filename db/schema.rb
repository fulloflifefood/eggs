# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110816223350) do

  create_table "account_location_tags", :force => true do |t|
    t.integer   "account_id"
    t.integer   "location_tag_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "account_transactions", :force => true do |t|
    t.date      "date"
    t.float     "amount"
    t.string    "description"
    t.integer   "member_id"
    t.integer   "order_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "debit"
    t.float     "balance"
    t.integer   "account_id"
    t.string    "paypal_transaction_id"
  end

  add_index "account_transactions", ["account_id"], :name => "index_account_transactions_on_account_id"
  add_index "account_transactions", ["order_id"], :name => "index_account_transactions_on_order_id"
  add_index "account_transactions", ["paypal_transaction_id"], :name => "index_account_transactions_on_paypal_transaction_id"

  create_table "accounts", :force => true do |t|
    t.integer   "member_id"
    t.integer   "farm_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "deposit_type",        :default => "unknown (old system)"
    t.boolean   "deposit_received",    :default => true
    t.boolean   "joined_mailing_list", :default => true
    t.boolean   "pending",             :default => false
    t.string    "referral"
    t.text      "private_notes"
    t.boolean   "is_inactive",         :default => false
  end

  add_index "accounts", ["farm_id"], :name => "index_accounts_on_farm_id"
  add_index "accounts", ["member_id"], :name => "index_accounts_on_member_id"

  create_table "backup", :force => true do |t|
    t.string    "storage"
    t.string    "trigger"
    t.string    "adapter"
    t.string    "filename"
    t.string    "path"
    t.string    "bucket"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "deliveries", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.integer   "farm_id"
    t.date      "date"
    t.string    "status"
    t.timestamp "opening_at"
    t.timestamp "closing_at"
    t.text      "notes"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "minimum_order_total"
    t.boolean   "deductions_complete", :default => false
    t.boolean   "finalized_totals",    :default => false
    t.boolean   "email_reminder_sent", :default => false
    t.boolean   "email_totals_sent",   :default => false
    t.boolean   "status_override",     :default => false
  end

  add_index "deliveries", ["farm_id"], :name => "index_deliveries_on_farm_id"

  create_table "delivery_order_reminders", :force => true do |t|
    t.integer   "delivery_id"
    t.integer   "email_template_id"
    t.boolean   "delivered",         :default => false
    t.timestamp "deliver_at"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "delivery_questions", :force => true do |t|
    t.integer "delivery_id"
    t.text    "description"
    t.text    "options"
    t.boolean "visible"
    t.string  "short_code"
    t.integer "product_question_id"
  end

  create_table "email_templates", :force => true do |t|
    t.string    "subject",    :null => false
    t.string    "from",       :null => false
    t.string    "bcc"
    t.string    "cc"
    t.text      "body",       :null => false
    t.text      "template"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "farm_id"
    t.text      "notes"
    t.string    "name"
    t.string    "identifier"
  end

  add_index "email_templates", ["farm_id", "identifier"], :name => "index_email_templates_on_farm_id_and_identifier"
  add_index "email_templates", ["farm_id"], :name => "index_email_templates_on_farm_id"

  create_table "farms", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "key"
    t.string    "paypal_link"
    t.string    "contact_email"
    t.string    "contact_name"
    t.string    "subdomain",                      :default => "soulfood"
    t.string    "mailing_list_subscribe_address"
    t.string    "address"
    t.boolean   "require_deposit",                :default => true
    t.boolean   "require_mailinglist",            :default => true
    t.boolean   "request_referral",               :default => true
    t.string    "paypal_account"
    t.boolean   "reminders_enabled",              :default => false
  end

  add_index "farms", ["name"], :name => "index_farms_on_name"
  add_index "farms", ["subdomain"], :name => "index_farms_on_subdomain"

  create_table "location_tags", :force => true do |t|
    t.string    "name"
    t.integer   "farm_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string    "name"
    t.string    "host_name"
    t.string    "host_phone"
    t.string    "host_email"
    t.string    "address"
    t.text      "notes"
    t.string    "time_window"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.integer   "farm_id"
    t.string    "label_color",     :default => "000000"
    t.integer   "location_tag_id"
  end

  add_index "locations", ["farm_id"], :name => "index_locations_on_farm_id"

  create_table "members", :force => true do |t|
    t.string    "first_name"
    t.string    "last_name"
    t.string    "email_address"
    t.string    "phone_number"
    t.string    "neighborhood"
    t.date      "joined_on"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "address"
    t.string    "alternate_email"
    t.text      "notes"
  end

  create_table "order_items", :force => true do |t|
    t.integer   "stock_item_id"
    t.integer   "order_id"
    t.integer   "quantity"
    t.text      "notes"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["stock_item_id"], :name => "index_order_items_on_stock_item_id"

  create_table "order_questions", :force => true do |t|
    t.integer "order_id"
    t.integer "delivery_question_id"
    t.string  "option_code"
    t.string  "option_string"
  end

  create_table "orders", :force => true do |t|
    t.integer   "member_id"
    t.integer   "delivery_id"
    t.text      "notes"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.float     "finalized_total"
    t.integer   "location_id"
  end

  add_index "orders", ["delivery_id"], :name => "index_orders_on_delivery_id"
  add_index "orders", ["location_id"], :name => "index_orders_on_location_id"
  add_index "orders", ["member_id"], :name => "index_orders_on_member_id"

  create_table "pickups", :force => true do |t|
    t.integer   "delivery_id"
    t.integer   "location_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "pickups", ["delivery_id"], :name => "index_pickups_on_delivery_id"
  add_index "pickups", ["location_id"], :name => "index_pickups_on_location_id"

  create_table "product_questions", :force => true do |t|
    t.integer   "farm_id"
    t.text      "description"
    t.text      "options"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "short_code"
  end

  create_table "products", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.float     "price"
    t.boolean   "estimated"
    t.integer   "farm_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "price_code"
    t.string    "category"
    t.integer   "default_quantity",   :default => 100
    t.integer   "default_per_member", :default => 4
    t.integer   "position"
    t.boolean   "subscribable",       :default => false
  end

  add_index "products", ["farm_id"], :name => "index_products_on_farm_id"

  create_table "roles", :force => true do |t|
    t.string    "name",              :limit => 40
    t.string    "authorizable_type", :limit => 40
    t.integer   "authorizable_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "roles", ["authorizable_type", "authorizable_id"], :name => "index_roles_on_authorizable_type_and_authorizable_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "snippets", :force => true do |t|
    t.string    "title"
    t.text      "body"
    t.string    "identifier"
    t.integer   "farm_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  add_index "snippets", ["farm_id", "identifier"], :name => "index_snippets_on_farm_id_and_identifier"
  add_index "snippets", ["farm_id"], :name => "index_snippets_on_farm_id"

  create_table "stock_items", :force => true do |t|
    t.integer   "delivery_id"
    t.integer   "product_id"
    t.integer   "max_quantity_per_member"
    t.integer   "quantity_available"
    t.boolean   "substitutions_available"
    t.text      "notes"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.boolean   "hide"
    t.string    "product_name"
    t.text      "product_description"
    t.float     "product_price"
    t.boolean   "product_estimated"
    t.string    "product_price_code"
    t.string    "product_category"
    t.integer   "position"
  end

  add_index "stock_items", ["delivery_id"], :name => "index_stock_items_on_delivery_id"
  add_index "stock_items", ["product_id"], :name => "index_stock_items_on_product_id"

  create_table "subscription_transactions", :force => true do |t|
    t.integer   "amount"
    t.string    "description"
    t.integer   "order_id"
    t.boolean   "debit",           :default => false
    t.integer   "balance"
    t.integer   "subscription_id"
    t.date      "date"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "notes"
  end

  add_index "subscription_transactions", ["subscription_id"], :name => "index_subscription_transactions_on_subscription_id"

  create_table "subscriptions", :force => true do |t|
    t.integer   "product_id"
    t.integer   "account_id"
    t.timestamp "created_at"
    t.timestamp "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string    "phone_number"
    t.timestamp "created_at"
    t.timestamp "updated_at"
    t.string    "crypted_password"
    t.string    "password_salt"
    t.string    "persistence_token"
    t.string    "email"
    t.integer   "member_id"
    t.string    "perishable_token"
    t.boolean   "active",            :default => false, :null => false
  end

  add_index "users", ["member_id"], :name => "index_users_on_member_id"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
