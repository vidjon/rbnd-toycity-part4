
module Analyzable
  def print_report(products)
      hash = {"Average Price" => 0, "Brand" => {}, "Name" => {}}
      products.each_with_index do  |product, index|
          hash["Average Price"] = (index == products.length - 1) ? ((hash["Average Price"] + product.price) / products.length) : (hash["Average Price"] + product.price)
          hash["Brand"].has_key?(product.brand) ? (hash["Brand"][product.brand] += 1) :(hash["Brand"][product.brand] = 1)
          hash["Name"].has_key?(product.name) ? (hash["Name"][product.name] += 1) :(hash["Name"][product.name] = 1)
      end
      string = ''
      hash.each do |key, value|
          if key == "Average Price"
              string += key + ": $" + value.to_s
          else
             string += "Inventory by " + key + ":"
             value.each do |key2, value2| string += "- " + key2 + ": " +value2.to_s end
          end
      end
      return string
  end

  def average_price(products)
      hash = {"Average Price" => 0}
      products.each_with_index do  |product, index|
          hash["Average Price"] = (index == products.length - 1) ? ((hash["Average Price"] + product.price) / products.length) : (hash["Average Price"] + product.price)
      end
      return hash["Average Price"].round(2)
  end

  def method_missing(method_name, *arguments)
      if method_name.to_s.start_with?("count_by_")
          length_of_find_by = "count_by_".length
          argument = method_name[length_of_find_by..method_name.length - 1]
          create_count_methods(argument)
          public_send(method_name, *arguments)
      end
  end

  def create_count_methods(attribute)
      class_eval("def count_by_#{attribute}(products)
          hash = {}
          products.each_with_index do  |product, index|
              hash.has_key?(product.#{attribute}) ? (hash[product.#{attribute}] += 1) : (hash[product.#{attribute}] = 1)
          end
          return hash
      end")
  end

  #def count_by_brand(products)
    #  hash = {}
     # products.each_with_index do  |product, index|
    #      hash.has_key?(product.brand) ? (hash[product.brand] += 1) : (hash[product.brand] = 1)
     # end
      #return hash
  #end

  #def count_by_name(products_with_name)
    #  return {products_with_name.first.name => products_with_name.length}
  #end
end
