ActiveRecord::Schema.define(:version => 1) do

  create_table "products", :force => true do |t|
    t.string   "product_type_cd"
    t.integer  "price"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "item_masters", :force => true do |t|
    t.string   "category_name", :limit => 20
    t.integer  "item_no"
    t.string   "item_cd", :limit => 2
    t.string   "name", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "i18n_item_masters", :force => true do |t|
    t.string   "locale", :limit => 5
    t.string   "category_name", :limit => 20
    t.integer  "item_no"
    t.string   "item_cd", :limit => 2
    t.string   "name", :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
end
