class VotesController < ApplicationController
  before_action :require_authentication!

  def create
    event_id = params[:event_id]
    user_id = current_user_id
    vote_type = params[:vote_type]

    if vote_type == 'upvote'
      command = Voting::Upvote.new(event_id: event_id, user_id: user_id)
    elsif vote_type == 'downvote'
      command = Voting::Downvote.new(event_id: event_id, user_id: user_id)
    end

    if command
      Rails.configuration.command_bus.call(command)
      redirect_to events_path, notice: "Vote recorded successfully."
    end
  end
end
