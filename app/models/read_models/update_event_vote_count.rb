module ReadModels
  class UpdateEventVoteCount
    include Handler.async(queue: "low")
    
    subscribes_to Voting::EventUpvoted, Voting::EventDownvoted

    def call(fact)
      event_id = fact.data.fetch(:event_id)
      
      ActiveRecord::Base.transaction do
        event_record = Event.find_by!(external_id: event_id)
        event_record.with_lock do
          event_record.vote_count ||= 0
          if fact.is_a?(Voting::EventUpvoted)
            event_record.vote_count += 1
          elsif fact.is_a?(Voting::EventDownvoted)
            event_record.vote_count -= 1
          end
          event_record.save!
        end
      end
    end
  end
end
