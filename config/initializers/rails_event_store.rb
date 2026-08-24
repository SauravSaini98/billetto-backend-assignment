require 'rails_event_store'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  # Self-executing commands act as their own handlers
  Rails.configuration.command_bus.register(Voting::Upvote, ->(cmd) { cmd.call })
  Rails.configuration.command_bus.register(Voting::Downvote, ->(cmd) { cmd.call })

  # Register subscriptions
  Voting.subscriptions.each do |event_class, handlers|
    handlers.each do |handler|
      Rails.configuration.event_store.subscribe(handler, to: [event_class])
    end
  end

  # Fallback manual registration for the test environment mock
  Rails.configuration.event_store.subscribe(
    ReadModels::UpdateEventVoteCount.new,
    to: [Voting::EventUpvoted, Voting::EventDownvoted]
  )
end
