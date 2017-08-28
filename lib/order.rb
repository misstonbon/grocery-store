require 'csv'

# og code using hash products
module Grocery

  class Order
    attr_reader :id, :products

    def initialize(id, products)
      @id = id
      @products = products
    end

    def total
      subtotal = @products.values.inject(0, :+)
      withtax = subtotal + subtotal * 0.075
      return withtax.round(2)
    end

    def add_product(product_name, product_price)
      unless @products.has_key?(product_name)
        @products[product_name] = product_price
        return true
      else
        return false
      end
    end

    def remove_product(product_name)
      if @products.has_key?(product_name)
        @products.delete(product_name)
        return true
      else
        return false
      end #maybe use pop here or remove ?
    end

    def self.all
      orders = []
      CSV.open("../support/orders.csv", 'r').each do |line|
        id = line[0].to_i
        # line[1] = line[1].split(';')
        # line[1] = line[1].gsub!':' '=>'
        # products = line[1].to_h
        products_hash = {}
        products_arr = line[1].split';'
        products_arr.each do |item_and_price|
          product_price = item_and_price.split':'
          products_hash[product_price[0]] = product_price[1].to_f

        end
        orders << self.new(id, products_hash)
      end
      return orders
    end

    def self.find(id)
      orders = Order.all
      unless (0..orders.length).include?(id)
        raise ArgumentError.new("Invalid id: #{id}")
      end

      found_order = nil
      orders.each do |order|
        if order.id == id
          found_order = order
        end
      end
      return found_order
    end
  end
end
