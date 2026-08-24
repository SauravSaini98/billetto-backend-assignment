require 'rails_helper'

RSpec.describe "Voting Flow", type: :system do
  before do
    driven_by(:rack_test)
    Event.create!(title: "Capybara Event", external_id: "capy_1", start_at: Time.current, vote_count: 0)
  end

  it "shows sign in for unauthenticated users" do
    visit events_path
    
    expect(page).to have_content("Capybara Event")
    expect(page).to have_content("Sign in to vote")
    expect(page).not_to have_button("Upvote (Like)")
  end

  it "allows voting for authenticated users" do
    clerk_mock = double("Clerk", session: double("Session", user_id: "user_123"))
    allow_any_instance_of(ApplicationController).to receive(:clerk).and_return(clerk_mock)

    visit events_path
    expect(page).to have_button("Upvote (Like)")

    click_button "Upvote (Like)"
    expect(page).to have_content("Vote recorded successfully.")
  end
end
