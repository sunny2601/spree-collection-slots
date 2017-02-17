module Spree
  class CollectionSlot < ActiveRecord::Base
    acts_as_paranoid

    belongs_to :shipping_method, inverse_of: :collection_slots

    validates :shipping_method, :start_time, :end_time, presence: true
    validates_with ::Spree::TimeFrameValidator, ::Spree::DeliverySlotUniqueValidator, unless: :deleted?, if: [:start_time?, :end_time?]

    before_update :create_duplicate_collection_slot, if: :time_frame_changed?
    before_update :reload_and_set_deleted_at, if: :time_frame_changed?

    def start_time
      super.try(:in_time_zone)
    end

    def end_time
      super.try(:in_time_zone)
    end

    def overlaps_with?(other_collection_slot)
      (other_collection_slot.start_time < end_time) &&
      (start_time < other_collection_slot.end_time)
    end

    def time_frame
      "#{ I18n.l(start_time, format: :frame_time) } - #{ I18n.l(end_time, format: :frame_time) }"
    end

    private
      def create_duplicate_collection_slot
        new_collection_slot = self.dup
        ## `new_collection_slot` is not required to validate here.
        ## As all its values are already through original time slot.
        new_collection_slot.save(validate: false)
      end

      def reload_and_set_deleted_at
        self.reload
        self.deleted_at = Time.current
      end

      def time_frame_changed?
        start_time_changed? || end_time_changed?
      end
  end
end
