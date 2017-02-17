module Spree
  class CollectionSlotUniqueValidator < ActiveModel::Validator
    def validate(collection_slot)
      if collection_slot.shipping_method.collection_slots.detect { |other_collection_slot| (collection_slot != other_collection_slot) && collection_slot.overlaps_with?(other_collection_slot) }
        collection_slot.errors.add(:base, :overlapping_start_time_and_end_time)
      end
    end
  end
end
