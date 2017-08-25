require 'csv'

module Grocery
  class Customer
    attr_ reader :id, :info

    def initialize (id,email,address)
      @id = id
      @email = email
      @address = address
      @@customers << (self)
    end

    def self.all
      return @@customers
    end

    def self.all
      customers = []
      email = []
      address = []
        CSV.open("./support/customers.csv", 'r').each do |line|
          id = line[0].to_i
          email << line[1].split(",")
          address << line[2..line.length]
        end
        customers << self.new(id, email, address)
      return customers
    end #ends self.all
  end #ends class Customer
end  #ends Grocery
