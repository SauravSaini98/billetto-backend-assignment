class Event < ApplicationRecord
  include EventStoreInjector

  validates :title, presence: true, length: { maximum: 255 }
  validates :external_id, presence: true, uniqueness: true
  validates :vote_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :start_at, presence: true
  validates :image_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true
  validates :description, length: { maximum: 5000 }, allow_blank: true

  def upvote!(user_id)
    event_store.publish(
      Voting::EventUpvoted.strict(data: { event_id: external_id, user_id: user_id }),
      stream_name: "Event$#{external_id}"
    )
  end

  def downvote!(user_id)
    event_store.publish(
      Voting::EventDownvoted.strict(data: { event_id: external_id, user_id: user_id }),
      stream_name: "Event$#{external_id}"
    )
  end
end
