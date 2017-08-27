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
    it "Returns an array of all online orders" do
      # TODO: Your test code here!
      # Useful checks might include:
      #   - OnlineOrder.all returns an array
      #   - Everything in the array is an Order
      #   - The number of orders is correct
      #   - The customer is present
      #   - The status is present
      # Feel free to split this into multiple tests if needed
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







# require 'minitest/autorun'
# require 'minitest/reporters'
# require 'minitest/skip_dsl'
# require 'minitest/pride'
# require_relative '../lib/online_order'
# require_relative '../lib/customer'
#
# describe "OnlineOrder" do
#   before do
#     @online_orders = Grocery::OnlineOrder.all
#   end
#
#   describe "#initialize" do
#     it "Is a kind of Order" do
#       @online_orders[0].must_be_kind_of Grocery::Order
#     end
#
#     it "Can access the online order status, Order ID, products, and customer id" do
#       @online_orders[1].must_respond_to :status
#       @online_orders[20].must_respond_to :id
#       @online_orders[3].must_respond_to :customer_id
#       @online_orders[14].must_respond_to :products
#     end
#     it "Default status for and order is pending" do
#       order = Grocery::OnlineOrder.new(1,{"Lobster" =>17.18, "Annatto seed" => 58.38, "Camomile" =>83.21}, 25)
#
#       order.status.must_equal :pending
#     end
#   end # End of describe "#initialize"
#
#   describe "#total" do
#     it "Adds a shipping fee" do
#       @online_orders[0].total.must_equal 180.68
#     end
#
#     it "Doesn't add a shipping fee if there are no products" do
#       order = Grocery::OnlineOrder.new(123,{},25)
#       order.total.must_equal 0
#     end
#   end #end of describe "total"
#
#   describe "#add_product" do
#     it "Does not permit action for processing, shipped or completed statuses" do
#       proc{Grocery::OnlineOrder.new(1,{"Lobster" =>17.18, "Annatto seed" => 58.38, "Camomile" =>83.21}, 25,"processing").add_product("Lemons",1.99)}.must_raise ArgumentError
#     end
#
#     it "Permits action for pending and paid satuses" do
#       #orderstatus = pending, has no product so products. length = 0, when we add a product length should equal 1
#       order = order = Grocery::OnlineOrder.new(123,{},25)
#       order.add_product("Lemons",1.99)
#       order.products.length.must_equal 1
#     end
#   end # end of describe "#add_product"
#
#
#   describe "OnlineOrder.all" do
#
#     it "Everything in the array is an Order" do
#       @online_orders.each do |order|
#         order.must_be_kind_of Grocery::OnlineOrder
#       end
#     end
#
#     it "OnlineOrder.all returns an array" do
#       @online_orders.must_be_kind_of Array
#     end
#
#     it "The number of online orders is correct (100)" do
#       @online_orders.length.must_equal 100
#     end
#
#     #The wording on this prompt and the next is vauge. I'm not sure this test is targeted at extracting/working with the approptiate information
#     it "The customer is present - Raises and error if the customer ID doesn't exist" do
#       @online_orders.each do |order|
#         order.customer_id.wont_be_empty
#       end
#     end
#
#     it "The status is present - all users have a status." do
#       @online_orders.each do |order|
#         order.status.wont_be_empty
#       end
#     end
#   end
#
#   describe "OnlineOrder.find(ID)" do
#     it "Can find the first order from the CSV" do
#       Grocery::OnlineOrder.find(1).must_be_same_as Grocery::OnlineOrder.all.first
#     end
#     it "Can find the last order from the CSV" do
#       Grocery::OnlineOrder.find(100).must_be_same_as Grocery::OnlineOrder.all.last
#     end
#     it "Raises an error for an order that doesn't exist" do
#       proc{Grocery::OnlineOrder.find(123)}.must_raise ArgumentError
#     end
#   end #end of "OnlineOrder.find(id)"
#
#   describe "OnlineOrder.find_by_customer" do
    # before do
    #     Grocery::OnlineOrder.all
    #   end
    #
    # it "Returns an array of online orders for a specific customer ID" do
    #
    #   Grocery::OnlineOrder.find_by_customer(29).must_be_kind_of Array
    # end
    # it "Can access all the orders for a customer" do
    #   customer_orders_array = Grocery::OnlineOrder.find_by_customer(5)
    #   customer_orders_array.length.must_equal 1
    # end
    # it "Raises an error for an customer id that doesn't exist" do
    #   proc{Grocery::OnlineOrder.find_by_customer(1234)}.must_raise ArgumentError
    # end
#   end #end of "OnlineOrder.find_by_customer"
# end #end of "OnlineOrder"
