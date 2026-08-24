require 'rails_helper'

RSpec.describe "Votes", type: :request do
  let!(:event) { Event.create!(title: "Test Event", external_id: "evt_1", start_at: Time.current, vote_count: 0) }

  describe "POST /events/:event_id/votes" do
    context "when unauthenticated (no Clerk session)" do
      it "redirects to the Clerk sign-in url or root" do
        post event_votes_path(event.external_id, vote_type: 'upvote')
        
        # ApplicationController#require_authentication! redirects to clerk.sign_in_url || '/'
        expect(response.status).to eq(302)
        expect(flash[:alert]).to eq("You must be signed in to perform this action.")
      end
    end
  end
end
