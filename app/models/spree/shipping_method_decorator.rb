Spree::ShippingMethod.class_eval do
  has_many :collection_slots, dependent: :destroy, inverse_of: :shipping_method

  accepts_nested_attributes_for :collection_slots, allow_destroy: true, reject_if: :all_blank

  def collection_slots_time_frames
    [[Spree.t(:any_time), nil]].concat(collection_slots.map { |collection_slot| [collection_slot.time_frame, collection_slot.id] })
  end
end
