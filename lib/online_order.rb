
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
