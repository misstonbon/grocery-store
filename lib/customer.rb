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

    def self.all
        customers = []
        CSV.open("../support/customers.csv", 'r').each do |line|
          id = line[0].to_i
          email = line[1]
          address = line[2..5]
        customers << self.new(id, email, address)
      end
      return customers
    end #ends self.all
  end
end
