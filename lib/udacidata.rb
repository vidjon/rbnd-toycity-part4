require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
     @@data_path = File.dirname(__FILE__) + "/../data/data.csv"

      def self.create(attributes = nil)
          item_in_database = item_exists(self.new(attributes))
          if item_in_database.length == 1
              #attributes[:id] = item_in_database.first.id
              return item_in_database
          else
              new_item = self.new(attributes)
              add_to_database(new_item)
              return new_item
          end
      end

      def self.all
          items_in_database = []
          CSV.foreach(@@data_path, headers: true) do |row|
              items_in_database << self.new(id: row["id"].to_i ,brand: row["brand"], name: row["product"], price: row["price"].to_f)
          end
          return items_in_database
      end

      def self.add_to_database(item)
          CSV.open(@@data_path, "a+") do |csv|
            csv << [item.id, item.brand, item.name, item.price.to_s]
          end
      end

     def self.item_exists(product)
         return all.select{ |item| item.id == product.id && item.brand == product.brand && item.name == product.name && item.price == product.price }
     end

     def self.first(number_of_item = 0)
         return number_of_item == 0 ? all.first : all.first(number_of_item)
     end

     def self.last(number_of_item = nil)
         return number_of_item == nil ? all.last : all.last(number_of_item)
     end

     def self.find(item_id)
         item = all.select{|item| item.id == item_id}.first
         raise ProductNotFoundError , "Product not found with id #{item_id.to_s}" if item == nil
         return item
     end

     def self.destroy(item_id)
         table = CSV.table(@@data_path)
         #raise ProductNotFoundError , "Product #{item_id.to_s} not found to destroy" if (table.length == 0 || (table.length + 1) > item_id)
         product_to_delete = find(item_id)
         table.delete_if do |row|
             row[:id].to_i == item_id
         end

         File.open(@@data_path, 'w') do |f|
             f.write(table.to_csv)
        end
        return product_to_delete
     end

    def self.method_missing(method_name, *arguments)
        if method_name.to_s.start_with?("find_by_")
            length_of_find_by = "find_by_".length
            argument = method_name[length_of_find_by..method_name.length - 1]
            create_finder_methods(argument)
            self.public_send(method_name, *arguments)
        end
    end

    #def self.find_by_brand(brand_name)
    #     return all.select{|item| item.brand == brand_name}.first
    #end

    #def self.find_by_name(product_name)
    #    return all.select{|item| item.name == product_name}.first
    #end

    def self.where(attributes={})
        return all.select{|item|(!attributes[:id] || item.id == attributes[:id]) &&
            (!attributes[:brand] || item.brand == attributes[:brand]) &&
            (!attributes[:name] || item.name == attributes[:name]) &&
            (!attributes[:price] || item.price == attributes[:price])}
    end

    def update(attributes={})
        table = CSV.table(@@data_path)
        updated_item = nil
        table.each do |row|
            if row[:id].to_i == self.id
                if attributes[:brand]
                    row[:brand] = attributes[:brand]
                    self.brand = attributes[:brand]
                end
                if attributes[:name]
                    row[:product] = attributes[:name]
                    self.name = attributes[:name]
                end
                if attributes[:price]
                    row[:price] = attributes[:price]
                    self.price = attributes[:price]
                end
            end
        end

        File.open(@@data_path, 'w') do |f|
            f.write(table.to_csv)
        end
        return self
    end
end
