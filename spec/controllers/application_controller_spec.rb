require 'spec_helper'

class NoOpAccount
  include Billing::Tab

  def debit_authorized?(amount)
    true
  end

  def debit(amount)
    amount
  end

  def credit(amount)
    amount
  end
end

describe ApplicationController do
  it { should respond_to(:debit) }
  it { should respond_to(:credit) }
  it { should respond_to(:debit_authorized?) }

  describe "When the user can't pay for the service" do
    controller do
      def index
        raise Billing::NotEnoughFunds
      end
    end

    it "should return a payment required" do
      get :index
      response.code.should eql('402')
    end
  end

  describe "Tracking transactions" do
    controller do
      def index
        debit 5
        debit 2
        debit 3

        credit 2
        credit 1
        credit 5
        head :ok
      end

      def current_tab
        NoOpAccount.new
      end
    end

    it "should track all the debits" do
      get :index 

      controller.incurred_debits.should == 10
    end

    it "should track all the credits" do
      get :index

      controller.incurred_credits.should == 8
    end
  end
end

describe ApplicationController do
  describe "When it returns a 4xx" do
    controller do
      def index
        head 400
      end
    end

    it "should reset the charges" do
      controller.should_receive(:reset_credits_and_debits!)

      get :index
    end
  end

  describe "When it returns a 5xx" do
    controller do
      def index
        head 500
      end
    end

    it "should reset the charges" do
      controller.should_receive(:reset_credits_and_debits!)

      get :index
    end
  end
end

describe ApplicationController do
  describe "#failed_response" do
    four_hundreds = (400..450).to_a
    four_hundreds << 499
    five_hundreds = (500..511).to_a
    five_hundreds << 598
    five_hundreds << 599

    (four_hundreds + five_hundreds).each do |code|
      it "should be true when it's a #{code}" do
        controller.stub_chain(:response, :code).and_return(code)
        controller.response_failed?.should be_true
      end
    end
  end

  describe "#reset_credits_and_debits" do
    before(:each) do
      controller.stub(:current_tab).and_return(double('tab'))
    end

    it "should debit the credits" do
      controller.incurred_credits = 10
      controller.current_tab.should_receive(:debit).with(10)

      controller.reset_credits_and_debits!

      controller.incurred_credits = 0
    end

    it "should credit the debits" do
      controller.incurred_debits = 10
      controller.current_tab.should_receive(:credit).with(10)

      controller.reset_credits_and_debits!

      controller.incurred_debits = 0
    end
  end
end
