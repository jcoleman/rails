# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module Deduplicable
      extend ActiveSupport::Concern

      cattr_accessor :classes
      self.classes = []

      included do
        Deduplicable.classes << self
      end

      module ClassMethods
        def registry
          @registry ||= {}
        end

        def new(*, **)
          super.deduplicate
        end
      end

      def deduplicate
        self.class.registry[self] ||= deduplicated
      end
      alias :-@ :deduplicate

      private
        def deduplicated
          freeze
        end
    end
  end
end
