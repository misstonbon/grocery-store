
require 'csv'
require_relative 'order'

module Grocery

  # attr_accessor :status
  #
  class OnlineOrder < Order
    attr_reader  :status, :customer

    def initialize(id, products, customer_id, status)
      super(id, products)
      @status = status
      @customer = Grocery::Customer.find(customer_id)
    end

    def total
      if @products.count > 0 #!products.empty?
        return super + 10
      end

      return super
    end

    def add_product(product_name, product_price)
      if @status == :pending || @status == :paid
        super(product_name, product_price)
      else
        raise ArgumentError.new "Cannot be modified."
        # it can also just be set to false
      end
    end

    def self.all
      all_online_orders = []
      CSV.open("../support/online_orders.csv", "r").each do |line|
        # 1,Lobster:17.18;Annatto seed:58.38;Camomile:83.21,25,complete
        id = line[0].to_i
        status = line.last.to_sym
        customer_id = line[2].to_i
        products = {}
        line[1].split(";").each do |item_and_price|
          product = item_and_price.split(":")
          products[product[0]] = product[1].to_f
        end
        all_online_orders << Grocery::OnlineOrder.new(id, products, customer_id, status)
      end
      return all_online_orders
    end

    def self.find(id)
      found_order = nil
      online_orders = Grocery::OnlineOrder.all

      if (0..online_orders.length).include?(id)
        online_orders.each do |order|
          if order.id == id
            found_order = order
          end
        end
        #raise ArgumentError.new("Invalid id: #{id}")
      end

      return found_order
    end

    def self.find_by_customer(customer_id)
      online_orders = []
      Grocery::OnlineOrder.all.each do |order|
        if order.customer.id == customer_id
          online_orders << order
        end
      end
      return online_orders
    end

  end

end




# require 'csv'
# require_relative 'order'
#
# module Grocery
#   class OnlineOrder < Order
#
#     attr_reader :customer_id, :status
#     @@all_online_orders = []
#     def initialize(id, products, customer_id, status="pending" )
#       super(id, products)
#       #  @customer = Grocery::Customer.find(customer_id) #so that we use an instance of the Customer class instead of just the customer_id in the csv file to access data about each customer
#       @customer_id = customer_id
#       @status = status.to_sym
#     end
#
#     #no super because super takes the out put for orders and gives back @@all_orders, in this case we dont care about that we want all the online orders
#     def self.all
#       if @@all_online_orders.length > 0
#         return @@all_online_orders
#       end
#       CSV.open("../support/online_orders.csv", "r").each do |line|
#         id = line[0].to_i
#         customer_id = line[2]
#         status = line[3]
#         products_hash = {}
#         products_prices = line[1].split(';')
#         products_prices.each do |product|
#           ind_product_price = product.split(':')
#           products_hash[ind_product_price[0]] = ind_product_price[1].to_f
#         end
#         @@all_online_orders << self.new(id, products_hash, customer_id, status)
#       end
#       return @@all_online_orders
#     end
#
#     def self.find(id_input)
#       counter = 0
#       OnlineOrder.all.each do |order|
#         if order.id == id_input
#           counter += 1
#           return order
#         end
#       end
#       if counter == 0
#         raise ArgumentError.new("Invalid order number - order does not exist")
#       end
#     end
#
#     def self.find_by_customer(customer_id_input)
#       counter = 0
#       orders_array =[]
#       OnlineOrder.all.each do |order|
#         if order.customer_id == customer_id_input.to_s
#           counter += 1
#           orders_array << order
#         end
#       end
#       if counter == 0
#         raise ArgumentError.new("Invalid customer ID- customer does not exist")
#       end
#       return orders_array
#     end
#
#     def total
#       if super != 0
#         super + 10
#       else
#         return 0
#       end
#     end
#
#     def add_product(product, price)
#       case @status
#       when :paid, :pending
#         super(product, price)
#       when :complete, :processing, :shipped
#         raise ArgumentError.new("Error - You cannot add new products at this point in you order because your order status is #{status.to_s} .")
#       end
#     end
#   end
# end


# require 'csv'
# require_relative './order'
# require_relative './customer'
#
# module Grocery
#   class OnlineOrder < Order
#     attr_reader :id, :products, :customer
#     attr_accessor :status
#
#     def initialize(id, products = nil, customer_id, status )
#       @id = id
#       @products = products
#       @status = status.to_sym
#       @customer = Grocery::Customer.find(customer_id.to_i)
#       super(id, products)
#     end
#
#     def self.all
#       all_orders = []
#       CSV.read('../support/online_orders.csv').each do |line|
#         id = line[0]
#         customer_id = line[2].to_i
#         status = line[3].to_sym
#         product_hash = {}
#         products = line[1].split(";")
#         products.each do |item_and_price|
#           purchase = item_and_price.split(":")
#           product_hash[purchase[0]] = purchase[1]
#         end
#         all_orders.push(Grocery::OnlineOrder.new(id, product_hash, customer_id, status))
#         return all_orders
#       end
#
#
#     def total
#       return @products == nil ? 0 : super + 10
#     end
#
#     def add_product(product_name, product_price)
#       if @status == :pending || @status == :paid
#         super
#       else
#         raise ArgumentError.new("The product cannot be added to #{@status} order. ")
#       end
#     end
#
#       def self.find_by_customer(customer_id)
#         orders = OnlineOrder.all
#         customer_orders = []
#         orders.each do |order|
#           customer_orders << order if order.customer.id == customer_id
#         end
#         return "Customer does not exist." if customer_orders.empty?
#         customer_orders
#       end
#       # def self.find_by_customer(customer_id_input)
#       #   counter = 0
#       #   orders_array =[]
#       #   OnlineOrder.all.each do |order|
#       #     if order.customer_id == customer_id_input.to_s
#       #       counter += 1
#       #       orders_array << order
#       #     end
#       #   end
#       #   if counter == 0
#       #     raise ArgumentError.new("Invalid customer ID")
#       #   end
#       #   return orders_array
#       # end
#     end
#
#   end #end class
# end #end module
