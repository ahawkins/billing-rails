module Billing
  module Rails
    class Engine < ::Rails::Engine
      initializer "billing.rails.action_controller" do
        ::ActionController::Base.send :include, Billing::Rails::ControllerHelpers
      end
    end
  end
end
