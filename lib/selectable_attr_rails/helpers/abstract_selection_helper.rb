module SelectableAttrRails::Helpers
  class AbstractSelectionBuilder
    attr_reader :entry_hash

    def initialize(object, object_name, method, options, template)
      @object, @object_name, @method = object, object_name, method
      @base_name = @object.class.enum_base_name(method.to_s)
      @template = template
      @entry_hash = nil
      @options = options || {}
      @entry_hash_array = @options[:entry_hash_array]
    end

    def enum_hash_array_from_object
      base_name = @object.class.enum_base_name(@method.to_s)
      @object.send("#{base_name}_hash_array")
    end

    def enum_hash_array_from_class
      base_name = @object.class.enum_base_name(@method.to_s)
      @object.class.send("#{base_name}_hash_array")
    end

    def tag_id(tag)
      result = nil
      tag.scan(/ id\=\"(.*?)\"/){|s|result = s}
      return result
    end

    def add_class_name(options, class_name)
      (options ||= {}).stringify_keys!
      (options['class'] ||= '') << ' ' << class_name
      options
    end

    def camelize_keys(hash, first_letter = :lower)
      result = {}
      hash.each{|key, value|result[key.to_s.camelize(first_letter)] = value}
      result
    end

    def update_options(dest, *options_array)
      result = dest || {}
      options_array.each do |options|
        next unless options
        if class_name = options.delete(:class)
          add_class_name(result, class_name)
        end
        result.update(options)
      end
      result
    end

  end
end
