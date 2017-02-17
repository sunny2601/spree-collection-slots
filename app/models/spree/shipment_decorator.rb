Spree::Shipment.class_eval do
  belongs_to :collection_slot

  delegate :is_collection_slots_enabled?, to: :shipping_method, allow_nil: true

  validate :verify_collection_slot, if: [:is_collection_slots_enabled?, :collection_slot]

  before_save :ensure_valid_collection_slot, if: :collection_slot

  def collection_slot
    Spree::CollectionSlot.unscoped { super }
  end

  def collection_slot_time_frame
    collection_slot ? collection_slot.time_frame : Spree.t(:any_time)
  end

  private
    def ensure_valid_collection_slot
      unless is_collection_slots_enabled?
        self.collection_slot_id = nil
      end
    end

    def verify_collection_slot
      if collection_slot.shipping_method != shipping_method
        self.errors.add(:collection_slot_id, :should_belongs_to_correct_shipping_method)
      end
    end
end
