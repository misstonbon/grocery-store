module Grocery
  class Order
    attr_reader :id, :products

    def initialize(id, products)
      @id = id
      @products = products
      #@products_arr = []
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

    # def user_adds_product(new_product)
    #   puts "Name:"
    #   product_name = gets.chomp
    #   puts "Price:"
    #   product_price = gets.chomp
    #   new_product.add_product
    # end


    def remove_product(product_name)
      if @products.has_key?(product_name)
        @products.delete(product_name)
        return true
      else
        return false
      end

    end
  end
end



# new_order = Grocery::Order.new(234, {"salad" => 2.99 })
