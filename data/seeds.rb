require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  Product.create(brand: "Udacity1", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity2", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity3", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity4", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity5", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity6", name: "yoyo", price: 10.00)
  Product.create(brand: "Udacity7", name: "yoyo", price: 10.00)
end
