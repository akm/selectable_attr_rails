module SelectableAttrRails::Helpers
  module SelectHelper
    module Base
      def self.included(base)
        base.module_eval do
          alias_method_chain :select, :attr_enumeable
        end
      end
      
      # def select_with_attr_enumeable(object, method, choices, options = {}, html_options = {})
      def select_with_attr_enumeable(object_name, method, *args, &block)
        if args.length > 3
          raise ArgumentError, "argument must be " <<
            "(object, method, choices, options = {}, html_options = {}) or " <<
            "(object, method, options = {}, html_options = {})"
        end
        return select_without_attr_enumeable(object_name, method, *args, &block) if args.length == 3
        return select_without_attr_enumeable(object_name, method, *args, &block) if args.first.is_a?(Array)
        options, html_options = *args
        options = update_enum_select_options(options, object_name, method)
        object, base_name = options[:object], options[:base_name]
        return multi_enum_select(object_name, method, options, html_options, &block) if object.respond_to?("#{base_name}_hash_array")
        return single_enum_select(object_name, method, options, html_options, &block) if object.class.respond_to?("#{base_name}_hash_array")
        raise ArgumentError, "invaliad argument"
      end
      
      def single_enum_select(object_name, method, options = {}, html_options = {}, &block)
        options = update_enum_select_options(options, object_name, method)
        object = options.delete(:object)
        base_name = options.delete(:base_name)
        entry_hash_array = options.delete(:entry_hash_array) || object.class.send("#{base_name}_hash_array")
        container = entry_hash_array.map{|hash| [hash[:name].to_s, hash[:id]]}
        select_without_attr_enumeable(object_name, method, container, options, html_options || {}, &block)
      end
      
      def multi_enum_select(object_name, method, options = {}, html_options = {}, &block)
        html_options = {:size => 5, :multiple => 'multiple'}.update(html_options || {})
        options = update_enum_select_options(options, object_name, method)
        object = options.delete(:object)
        base_name = options.delete(:base_name)
        entry_hash_array = options.delete(:entry_hash_array) || object.send("#{base_name}_hash_array")
        container = entry_hash_array.map{|hash| [hash[:name].to_s, hash[:id].to_s]}
        attr = "#{base_name}_ids"
        select_without_attr_enumeable(object_name, attr, container, options, html_options, &block)
      end
      
      def update_enum_select_options(options, object_name, method)
        options ||= {}
        object = (options[:object] ||= instance_variable_get("@#{object_name}"))
        options[:base_name] ||= object.class.enum_base_name(method.to_s)
        options
      end
    end
    
    module FormBuilder
      def self.included(base)
        base.module_eval do
          alias_method_chain :select, :attr_enumeable
        end
      end

      # def select_with_attr_enumeable(method, choices, options = {}, html_options = {}, &block)
      def select_with_attr_enumeable(method, *args, &block)
        options = args.first.is_a?(Array) ? (args[1] ||= {}) : (args[0] ||= {})
        object = (options || {}).delete(:object) || @object || instance_variable_get(@object_name) rescue nil
        options.update({:object => object})
        options[:selected] = object.send(method) if object
        @template.select(@object_name, method, *args, &block)
      end
    end
  end
end
