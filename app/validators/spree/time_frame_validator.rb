module Spree
  class TimeFrameValidator < ActiveModel::Validator
    def validate(collection_slot)
      if collection_slot.start_time >= collection_slot.end_time
        collection_slot.errors.add(:start_time, :less_than_end_time)
      end
    end
  end
end
