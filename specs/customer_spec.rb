require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/customer'

describe "Customer" do

  before do
    @customers = Grocery::Customer.all
  end

  describe "#initialize" do

    it "Takes an ID, email and address info" do
      @customers.first.id.must_equal 1
      @customers.last.id.must_equal 35
      @customers.first.email.must_equal "leonard.rogahn@hagenes.org"
      @customers.last.email.must_equal "rogers_koelpin@oconnell.org"
      @customers.first.address.must_equal ["71596 Eden Route", "Connellymouth", "LA", "98872-9105"]
      @customers.last.address.must_equal ["7513 Kaylee Summit", "Uptonhaven", "DE", "64529-2614"]
    end

    describe "Customer.all" do

      it "Returns an array of all customers" do
        @customers.must_be_kind_of Array
      end

      it "Customer.all returns an array" do
        Grocery::Customer.all.must_be_kind_of Array
      end

      it " Everything in the array is a Customer" do
        @customers.must_be_kind_of Array

        @customers.each do |customer|
          customer.must_be_kind_of Grocery::Customer
        end
      end
    end
#
    describe "Customer.find" do

      before do
        @customers = Grocery::Customer.all
      end

      it "Can find the first customer from the CSV" do
        csv_email = []
        CSV.open("../support/customers.csv", 'r').each do |line|
          csv_email << line[1]
        end

        csv_email.include?(Grocery::Customer.find(1).email).must_equal true
        # Grocery::Customer.find(1).email.must_equal csv_email.first
      end
    end

    it "Can find the last customer from the CSV" do
      Grocery::Customer.find(35).email.must_equal "rogers_koelpin@oconnell.org"
    end

    it "Raises an error for a customer that doesn't exist" do
      proc {Grocery::Customer.find(123)}.must_raise ArgumentError
    end

  end
end
