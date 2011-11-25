module Billing
  module Rails
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        include Billing::Tab
        include Billing::Helpers
        include TransactionTracking

        rescue_from Billing::NotEnoughFunds do
          render :text => 'You do not have enough money in your account', :status => :payment_required
        end

        after_filter :reset_credits_and_debits!, :if => :response_failed?
      end

      def current_tab
        raise "Define this method in AppplicationController before using billing"
      end

      def reset_credits_and_debits!
        current_tab.credit(incurred_debits) if incurred_debits && incurred_debits > 0
        current_tab.debit(incurred_credits) if incurred_credits && incurred_credits > 0
        self.incurred_debits = 0
        self.incurred_credits = 0
      end

      def response_failed?
        !(200..399).include?(response.code.to_i)
      end
    end
  end
end
