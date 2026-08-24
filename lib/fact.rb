require 'rails_event_store'

class Fact < RubyEventStore::Event
  def self.strict(data:)
    # Simple validation mock for the test
    missing = self::SCHEMA.keys - data.keys
    raise ArgumentError, "Missing keys: #{missing}" if missing.any?
    new(data: data)
  end
end
