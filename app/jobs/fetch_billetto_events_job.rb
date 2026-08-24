class FetchBillettoEventsJob < ApplicationJob
  queue_as :default

  def perform
    Billetto::FetchEventsService.new.call
  end
end
