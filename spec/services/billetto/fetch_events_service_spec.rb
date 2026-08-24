require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Billetto::FetchEventsService do
  describe '#call' do
    let(:api_key) { 'test_api_key' }
    let(:service) { described_class.new(api_key: api_key) }
    
    before do
      stub_request(:get, "https://billetto.dk/api/v3/public/events?limit=100")
        .with(headers: { 'Api-Keypair' => api_key })
        .to_return(status: 200, body: {
          data: [
            { 'id' => 'evt_1', 'title' => 'Test Event 1', 'startdate' => '2023-01-01T10:00:00Z', 'image_link' => 'http://example.com/img1.png', 'description' => 'Desc 1' },
            { 'id' => 'evt_2', 'title' => 'Test Event 2', 'startdate' => '2023-01-02T10:00:00Z', 'image_link' => 'http://example.com/img2.png', 'description' => 'Desc 2' }
          ]
        }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches and ingests events' do
      expect { service.call }.to change { Event.count }.by(2)
      
      expect(Event.find_by(external_id: "evt_1").title).to eq("Test Event 1")
      expect(Event.find_by(external_id: "evt_2").title).to eq("Test Event 2")
    end
  end
end
