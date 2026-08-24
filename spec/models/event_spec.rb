require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      event = Event.new(title: 'Test Event', external_id: '123', start_at: Time.current, vote_count: 0)
      expect(event).to be_valid
    end

    it 'is invalid without a title' do
      event = Event.new(title: nil, external_id: '123', start_at: Time.current)
      expect(event).to_not be_valid
    end

    it 'is invalid without a date (start_at)' do
      event = Event.new(title: 'Test Event', external_id: '123', start_at: nil)
      expect(event).to_not be_valid
    end

    it 'is invalid with a negative vote count' do
      event = Event.new(title: 'Test Event', external_id: '123', start_at: Time.current, vote_count: -1)
      expect(event).to_not be_valid
    end
  end
end
