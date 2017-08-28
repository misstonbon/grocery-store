require 'csv'

module Grocery
  class Customer
    attr_accessor :id, :email, :address

    def initialize(id, email, address)
      @id = id
      @email = email
      @address = address
      #@@customers << (self)
    end

    # def self.all
    #   return @@customers
    # end
    #class var, you're killing me!

    def self.all
      customers = []
      CSV.open("../support/customers.csv", 'r').each do |line|
        id = line[0].to_i
        email = line[1]
        address = line[2..-1]
        customers << self.new(id, email, address)
      end
      return customers
    end #ends self.all

    def self.find(id)
      customers = Customer.all
      unless (0..customers.length).include?(id)
        raise ArgumentError.new("Invalid id: #{id}")
      end
      found_customer = nil
      customers.each do |customer|
        if customer.id == id
          found_customer = customer
        end
      end
      return found_customer
    end
  end
end
