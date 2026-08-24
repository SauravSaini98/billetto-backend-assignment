module Voting
  def self.subscriptions
    [
      ReadModels::UpdateEventVoteCount
    ].map { |c| c.respond_to?(:subscriptions) ? c.subscriptions : {} }.reduce(&:merge) || {}
  end
end
