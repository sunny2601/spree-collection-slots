require 'spec_helper'

module Spree
  describe ShippingMethod do
    describe 'Associations' do
      it { is_expected.to have_many(:collection_slots).inverse_of(:shipping_method).dependent(:destroy) }
    end

    describe 'Accepts nested attributes for' do
      it { is_expected.to accept_nested_attributes_for(:collection_slots).allow_destroy(true) }
    end

    describe '#collection_slots_time_frames' do
      let!(:collection_slot_enabled_shipping_method) { create(:shipping_method, is_collection_slots_enabled: true) }
      let!(:collection_slot1) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
      let!(:collection_slot2) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

      subject do
        collection_slot_enabled_shipping_method.collection_slots.reload
        collection_slot_enabled_shipping_method.collection_slots_time_frames
      end

      it { is_expected.to include([collection_slot1.time_frame, collection_slot1.id]) }
      it { is_expected.to include([collection_slot2.time_frame, collection_slot2.id]) }
      it { is_expected.to include([Spree.t(:any_time), nil]) }
    end
  end
end
