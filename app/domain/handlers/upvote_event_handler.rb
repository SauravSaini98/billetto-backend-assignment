module Handlers
  class UpvoteEventHandler
    def call(command)
      event = Events::EventUpvoted.new(data: {
        event_id: command.event_id,
        user_id: command.user_id
      })
      Rails.configuration.event_store.publish(event, stream_name: "Event$#{command.event_id}")
    end
  end
end
