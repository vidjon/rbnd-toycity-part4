class Module
  def create_finder_methods(attribute)
      self.class_eval("def self.find_by_#{attribute}(find_by_arg) self.all.select{|item| item.#{attribute} == find_by_arg}.first end")

    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
  end
end
