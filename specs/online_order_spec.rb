require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

require_relative '../lib/customer'
require_relative '../lib/online_order'

describe "OnlineOrder" do
  describe "#initialize" do
    it "Is a kind of Order" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.must_be_kind_of Grocery::Order
    end

    it "Can access Customer object" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.customer.must_be_kind_of Grocery::Customer
    end

    it "Can access the online order status" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.status.must_equal :pending
    end

    it "Can access the online order id" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.id.must_equal 12
    end

    it "Can access the online order products" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.products.must_be_kind_of Hash
    end

  end

  describe "#total" do
    it "Adds a shipping fee" do
      o = Grocery::OnlineOrder.find(15)
      o.total.must_equal 101.76
    end

    it "Doesn't add a shipping fee if there are no products" do
      online_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      online_order.total.must_equal 0.0
    end
  end

  describe "#add_product" do
    it "Does not permit action for processing, shipped or completed statuses" do
      processing_order = Grocery::OnlineOrder.new(12, {}, 2, :processing)
      #processing_order.add_product("Lemons", 1.99).must_equal false
      proc{ processing_order.add_product("Lemons",1.99)}.must_raise ArgumentError

      shipped_order = Grocery::OnlineOrder.new(12, {}, 2, :shipped)
      proc{ shipped_order.add_product("Lemons",1.99)}.must_raise ArgumentError

      completed_order = Grocery::OnlineOrder.new(12, {}, 2, :completed)
      proc{ completed_order.add_product("Lemons",1.99)}.must_raise ArgumentError

    end

    it "Permits action for pending and paid satuses" do
      pending_order = Grocery::OnlineOrder.new(12, {}, 2, :pending)
      pending_order.add_product("Lemons", 1.99).must_equal true

      paid_order = Grocery::OnlineOrder.new(12, {}, 2, :paid)
      paid_order.add_product("Lemons", 1.99).must_equal true

    end
  end

  describe "OnlineOrder.all" do
    before do
      @online_orders = Grocery::OnlineOrder.all
    end

    it "Everything in the array is an Order" do
      @online_orders.each do |order|
        order.must_be_kind_of Grocery::OnlineOrder
      end
    end

    it "OnlineOrder.all returns an array" do
      @online_orders.must_be_kind_of Array
    end

    it "The number of online orders is correct (100)" do
      @online_orders.length.must_equal 100
    end

    #The wording on this prompt and the next is vauge. I'm not sure this test is targeted at extracting/working with the approptiate information
    it "The customer is present" do
      @online_orders.each do |order|
        order.customer.must_be_kind_of Grocery::Customer
      end
    end

    it "The status is present - all users have a status." do
      @online_orders.each do |order|
        order.status.wont_be_empty
      end
    end
  end

  describe "OnlineOrder.find_by_customer" do
    it "Returns an array of online orders for a specific customer ID" do
      o = Grocery::OnlineOrder.find_by_customer(25)
      o.must_be_kind_of Array
      o.first.must_be_instance_of Grocery::OnlineOrder
    end
    it "Can access all the orders for a customer" do
      customer_orders_array = Grocery::OnlineOrder.find_by_customer(5)
      customer_orders_array.length.must_equal 1
    end
    it "It returns an empty array for invalid customer ID" do
      Grocery::OnlineOrder.find_by_customer(1234).must_be_empty
    end
  end
end
