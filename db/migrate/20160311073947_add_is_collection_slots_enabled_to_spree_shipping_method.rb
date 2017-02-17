class AddIsCollectionSlotsEnabledToSpreeShippingMethod < ActiveRecord::Migration
  def change
    add_column :spree_shipping_methods, :is_collection_slots_enabled, :boolean, default: false, null: false
  end
end
