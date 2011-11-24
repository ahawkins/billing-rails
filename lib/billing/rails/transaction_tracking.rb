module Billing
  module Rails
    module TransactionTracking
      extend ActiveSupport::Concern

      included do
        attr_accessor :incurred_debits, :incurred_credits
      end

      def debit(*args)
        self.incurred_debits = 0 if incurred_debits.nil?
        cost = super
        self.incurred_debits = incurred_debits + cost
        cost
      end

      def credit(*args)
        self.incurred_credits = 0 if incurred_credits.nil?
        cost = super
        self.incurred_credits = incurred_credits + cost
        cost
      end
    end
  end
end
