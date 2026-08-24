require 'rails_helper'

RSpec.describe "Upvoting an Event", type: :request do
  let!(:event) { Event.create!(title: "Test Event", external_id: "evt_123", vote_count: 0, start_at: Time.current) }

  before do
    clerk_mock = double("Clerk", session: double("Session", user_id: "user_123"))
    allow_any_instance_of(ApplicationController).to receive(:clerk).and_return(clerk_mock)
  end

  it "dispatches a command, publishes an event, and updates the vote count" do
    expect {
      post event_votes_path(event.external_id, vote_type: 'upvote')
    }.to change { event.reload.vote_count }.by(1)

    # Verify event store contains the domain event
    stream = Rails.configuration.event_store.read.stream("Event$evt_123").to_a
    expect(stream.size).to eq(1)
    expect(stream.first).to be_a(Voting::EventUpvoted)
    expect(stream.first.data[:event_id]).to eq("evt_123")
  end
end
