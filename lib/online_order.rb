require 'csv'
require_relative './order'
require_relative

module Grocery
  class OnlineOrder < Grocery::Order
    attr_reader :id, :product, :customer, :status

    def initialize(id, products = 0, customer_id, status)
      @id = id
      @products = Grocery::Customer.find(customer_id)
      @status = status.to_sym
    end

    def total
      if @products != 0
        super + 10
      else 0
      end
    end

    def add_product(product_name, product_price)
      unless @status == :pending || @status == :paid
        raise ArgumentError.new "Cannot add product to #{@status} order."
      else
        super
      end
    end

    def self.all
      all_orders = []
      CSV.read('support/online_orders.csv').each do |line|
        id = line[0]
        customer_id = line[2]
        status = line[3].to_sym
        product_hash = {}
        products = line[1].split(";")
        products.each do |item_and_price|
          purchase = item_and_price.split(":")
          product_hash[purchase[0]] = purchase[1]
        end
        all_orders.push(Grocery::OnlineOrder.new(id,product_hash,customer_id,status))
        return all_orders
      end

      def self.find_by_customer(input)
        orders = []
        all_orders = self.all
        all_orders.each do |order|
          if order.id == input
            orders.push(order)
          end
        end
        if order.length == 0
          raise ArgumentError.new "#{@input} is an invalid customer ID."
        else
          return orders
        end
      end  
    end #end find_by_customer
  end #end class
end #end module
# rewrite add_product to raise ArgumentError unless paid or pending
