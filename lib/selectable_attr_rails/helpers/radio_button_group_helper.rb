module SelectableAttrRails::Helpers
  module RadioButtonGroupHelper
    class Builder < SelectableAttrRails::Helpers::AbstractSelectionBuilder

      attr_reader :entry_hash_array
      attr_reader :entry_hash
      attr_accessor :radio_button_id

      def initialize(object, object_name, method, options, template)
        super(object, object_name, method, options, template)
        @entry_hash_array ||= enum_hash_array_from_class
      end

      def each(&block)
        @entry_hash_array.each do |entry_hash|
          @entry_hash = entry_hash
          tag_value = @entry_hash[:id].to_s.gsub(/\s/, "_").gsub(/\W/, "").downcase
          @radio_button_id = "#{@object_name}_#{@method}_#{tag_value}"
          yield(self)
        end
      end

      def radio_button(options = nil)
        @template.radio_button(@object_name, @method, @entry_hash[:id],
          update_options({:id => @radio_button_id}, options))
      end

      def label(text = nil, options = nil)
        @template.content_tag("label", text || @entry_hash[:name],
          update_options({:for => @radio_button_id}, options))
      end
    end

    module Base
      def radio_button_group(object_name, method, options = nil, &block)
        object = (options || {})[:object] || instance_variable_get("@#{object_name}")
        builder = Builder.new(object, object_name, method, options, self)
        if block_given?
          yield(builder)
          return nil
        else
          result = ''
          builder.each do
            result << builder.radio_button
            result << builder.label
          end
          return result
        end
      end
    end

    module FormBuilder
      def radio_button_group(method, options = nil, &block)
        @template.radio_button_group(@object_name, method,
          (options || {}).merge(:object => @object), &block)
      end
    end
  end
end
