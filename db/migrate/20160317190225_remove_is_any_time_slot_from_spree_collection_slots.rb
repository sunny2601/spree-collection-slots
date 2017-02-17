class RemoveIsAnyTimeSlotFromSpreeCollectionSlots < ActiveRecord::Migration
  def up
    remove_column :spree_collection_slots, :is_any_time_slot
  end

  def down
    add_column :spree_collection_slots, :is_any_time_slot, :boolean, default: false, null: false
  end
end
