class CreateSpreeShipmentCollectionSlot < ActiveRecord::Migration
  def change
    create_table :spree_shipments_collection_slots do |t|
      t.references :shipment, index: true
      t.references :collection_slot, index: true
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
