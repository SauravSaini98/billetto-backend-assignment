module Voting
  class EventDownvoted < Fact
    SCHEMA = {
      event_id: String,
      user_id: String
    }.freeze

    def stream_names
      ["Event$#{data.fetch(:event_id)}"]
    end
  end
end
