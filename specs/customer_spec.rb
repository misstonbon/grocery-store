require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

# TODO: uncomment the next line once you start wave 3
# require_relative '../lib/customer'

describe "Customer" do
  before do
    @@customers = Customer.all
  end

  describe "#initialize" do

    it "It can be initialized " do
    Customer.must_respond_to :initialize
  end

    it "Takes an ID, email and address info" do
      
    end
  end

  describe "Customer.all" do
    it "Returns an array of all customers" do
      # TODO: Your test code here!
      # Useful checks might include:
    it "Customer.all returns an array"
    Customer.all.must_be_kind_of Array
  end

  it " Everything in the array is a Customer"
  @@customers.each.must_be_kind_of Customer
end
      #   - The number of orders is correct
      #   - The ID, email address of the first and last
      #       customer match what's in the CSV file
      # Feel free to split this into multiple tests if needed
    end
  end

  describe "Customer.find" do
    it "Can find the first customer from the CSV" do
      # TODO: Your test code here!
    end

    it "Can find the last customer from the CSV" do
      # TODO: Your test code here!
    end

    it "Raises an error for a customer that doesn't exist" do
      # TODO: Your test code here!
    end
  end
end
