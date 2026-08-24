require 'faraday'
require 'faraday/retry'

module Billetto
  class ApiError < StandardError; end

  class FetchEventsService
    API_URL = "https://billetto.dk/api/v3/public/events?limit=100".freeze

    def initialize(api_key: ENV['BILLETTO_API_KEY'])
      @api_key = api_key
      @connection = Faraday.new(url: API_URL) do |faraday|
        faraday.options.timeout = 10
        faraday.options.open_timeout = 5
        
        faraday.request :retry, max: 3, interval: 0.05,
                        interval_randomness: 0.5, backoff_factor: 2,
                        exceptions: [Faraday::TimeoutError, Faraday::ConnectionFailed]

        faraday.headers['Api-Keypair'] = @api_key
        faraday.headers['Accept'] = 'application/json'
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def call
      begin
        response = @connection.get
        if response.success?
          events = response.body.fetch('data', [])
          ingest_events(events)
        else
          Rails.logger.error("Failed to fetch events from Billetto: #{response.status} - #{response.body}")
          raise ApiError, "Billetto API returned #{response.status}"
        end
      rescue Faraday::Error => e
        Rails.logger.error("Network error while fetching events: #{e.message}")
        raise ApiError, "Network error: #{e.message}"
      end
    end

    private

    def ingest_events(events_data)
      events_data.each do |event_data|
        Event.find_or_initialize_by(external_id: event_data['id'].to_s).tap do |event|
          event.title = event_data['title']
          event.description = event_data['description']
          event.image_url = event_data['image_link']
          event.start_at = event_data['startdate'] || Time.current # Fallback if missing
          event.vote_count ||= 0
          event.save!
        end
      end
    end
  end
end
