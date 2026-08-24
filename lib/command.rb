module Command
  module Executable
    extend ActiveSupport::Concern
    include ActiveModel::Model
    include ActiveModel::Attributes

    class_methods do
      def attribute(name, type)
        super(name, type.to_s.downcase.to_sym)
      end
    end

    def call
      # This simulates the self-executing command pattern wrapping in a transaction
      ActiveRecord::Base.transaction do
        execute
      end
    end
  end

  module Handler
    # Used for non-executable commands, handled by a service
    extend ActiveSupport::Concern
    
    class_methods do
      def handles(command_class, method_name)
        # Mocking the registration logic for handlers
      end
    end
  end
end
