class AddCollectionSlotReferenceToSpreeShipment < ActiveRecord::Migration
  def change
    add_reference :spree_shipments, :collection_slot, index: true
  end
end
