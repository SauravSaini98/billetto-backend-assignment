module Handler
  def self.async(queue:)
    Module.new do
      extend ActiveSupport::Concern
      # Simulate ActiveJob inclusion for async handling
      include ActiveJob::Integration if defined?(ActiveJob::Integration)

      class_methods do
        def subscribes_to(*events)
          # Mocking subscription logic for the read models
        end
      end
    end
  end
end
