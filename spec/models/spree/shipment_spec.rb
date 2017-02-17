require 'spec_helper'

module Spree
  describe Shipment do
    let(:collection_slot_enabled_shipping_method) { create(:shipping_method, is_collection_slots_enabled: true) }
    let(:collection_slot_disabled_shipping_method) { create(:shipping_method, is_collection_slots_enabled: false) }

    describe 'Associations' do
      it { is_expected.to belong_to(:collection_slot) }
    end

    describe 'Delegate' do
      it { is_expected.to delegate_method(:is_collection_slots_enabled?).to(:shipping_method) }
    end

    describe 'Validations' do
      describe '#verify_collection_slot' do
        context 'when shipping method is collection slots enabled' do
          let(:collection_slot) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_enabled_shipping_method]
            shipment.collection_slot = collection_slot
            shipment
          end

          context 'when collection slot is present' do
            context 'when collection slot\'s shipping_method is not same as shipment\'s shipping_method' do
              let(:collection_slot_enabled_shipping_method2) { create(:shipping_method, is_collection_slots_enabled: true) }
              let(:collection_slot2) { collection_slot_enabled_shipping_method2.collection_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.collection_slot = collection_slot2
                shipment.valid?
              end

              it { expect(shipment).not_to be_valid }
              it { expect(shipment.errors[:collection_slot_id]).to include(I18n.t(:should_belongs_to_correct_shipping_method, scope: [:activerecord, :errors, :models, 'spree/shipment'])) }
            end

            context 'when collection slot\'s shipping_method is same as shipment\'s shipping_method' do
              let(:collection_slot2) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.collection_slot = collection_slot2
              end

              it { expect(shipment).to be_valid }
            end
          end

          context 'when collection slot is not present' do
            before do
              shipment.collection_slot = nil
            end

            it { expect(shipment).to be_valid }
          end
        end

        context 'when shipping method is not collection slots enabled' do
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_disabled_shipping_method]
            shipment
          end

          context 'when collection slot is present' do
            context 'when collection slot\'s shipping_method is not same as shipment\'s shipping_method' do
              let(:collection_slot_enabled_shipping_method2) { create(:shipping_method, is_collection_slots_enabled: true) }
              let(:collection_slot2) { collection_slot_enabled_shipping_method2.collection_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.collection_slot = collection_slot2
                shipment.valid?
              end

              it { expect(shipment).to be_valid }
            end

            context 'when collection slot\'s shipping_method is same as shipment\'s shipping_method' do
              let(:collection_slot2) { collection_slot_disabled_shipping_method.collection_slots.create!(start_time: Time.current + 4.hours, end_time: Time.current + 6.hours) }

              before do
                shipment.collection_slot = collection_slot2
              end

              it { expect(shipment).to be_valid }
            end
          end

          context 'when collection slot is not present' do
            before do
              shipment.collection_slot = nil
            end

            it { expect(shipment).to be_valid }
          end
        end
      end
    end

    describe 'Callbacks' do
      describe '#ensure_valid_collection_slot' do
        def update_shipping_methods(shipment, shipping_methods)
          shipment.shipping_methods = shipping_methods
          shipment.save
        end

        context 'when new shipping method is not collection slot disabled' do
          let(:collection_slot) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_enabled_shipping_method]
            shipment.collection_slot = collection_slot
            shipment
          end

          it 'expects to nullify collection_slot' do
            expect { update_shipping_methods(shipment, [collection_slot_disabled_shipping_method]) }
              .to change { shipment.collection_slot_id }.from(collection_slot.id).to(nil)
          end
        end

        context 'when new shipping method is collection slot disabled' do
          let(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_disabled_shipping_method]
            shipment
          end

          it 'expects to not nullify collection_slot' do
            expect { update_shipping_methods(shipment, [collection_slot_disabled_shipping_method]) }
              .to_not change { shipment.collection_slot_id }
          end
        end
      end
    end

    describe '#collection_slot_time_frame' do
      context 'when shipping method is collection slot enabled' do
        context 'when collection slot is present' do
          let!(:collection_slot) { collection_slot_enabled_shipping_method.collection_slots.create!(start_time: Time.current + 2.hours, end_time: Time.current + 4.hours) }
          let!(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_enabled_shipping_method]
            shipment.collection_slot = collection_slot
            shipment
          end

          it { expect(shipment.collection_slot_time_frame).to eq collection_slot.time_frame }
        end

        context 'when collection slot is not present' do
          let!(:shipment) do
            shipment = create(:shipment)
            shipment.shipping_methods = [collection_slot_enabled_shipping_method]
            shipment
          end

          it { expect(shipment.collection_slot_time_frame).to eq Spree.t(:any_time) }
        end
      end

      context 'when shipping method is not collection slot enabled' do
        let!(:shipment) do
          shipment = create(:shipment)
          shipment.shipping_methods = [collection_slot_disabled_shipping_method]
          shipment
        end

        it { expect(shipment.collection_slot_time_frame).to eq Spree.t(:any_time) }
      end
    end
  end
end
