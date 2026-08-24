namespace :billetto do
  desc "Fetch public events from Billetto API and ingest them into the local database"
  task fetch_events: :environment do
    api_key = ENV['BILLETTO_API_KEY']
    
    if api_key.blank?
      puts "Error: BILLETTO_API_KEY environment variable is missing."
      puts "Please check your .env file."
      exit 1
    end

    puts "Enqueueing Billetto events fetch job..."
    FetchBillettoEventsJob.perform_later
    puts "Job enqueued successfully! It will run in the background."
  end
end
