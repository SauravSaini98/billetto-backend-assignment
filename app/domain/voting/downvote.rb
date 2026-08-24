module Voting
  class Downvote
    include Command::Executable
    
    attribute :event_id, String
    attribute :user_id, String

    validates :event_id, :user_id, presence: true

    def execute
      # Idempotency check: verify if user already downvoted this event in the event store
      stream_name = "Event$#{event_id}"
      already_downvoted = Rails.configuration.event_store.read.stream(stream_name).to_a.any? do |fact|
        fact.is_a?(Voting::EventDownvoted) && fact.data[:user_id] == user_id
      end

      return if already_downvoted # No-op if already voted (idempotent)

      event = Event.find_by!(external_id: event_id)
      event.downvote!(user_id)
    end
  end
end
