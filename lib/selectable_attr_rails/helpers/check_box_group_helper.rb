require 'selectable_attr_rails/helpers/abstract_selection_helper'
module SelectableAttrRails::Helpers
  module CheckBoxGroupHelper
    class Builder < SelectableAttrRails::Helpers::AbstractSelectionBuilder

      def initialize(object, object_name, method, options, template)
        super(object, object_name, method, options, template)
        @entry_hash_array ||= enum_hash_array_from_object
        @param_name = "#{@base_name}_ids"
        @check_box_options = @options.delete(:check_box) || {}
      end

      def each(&block)
        @entry_hash_array.each do |entry_hash|
          @entry_hash= entry_hash
          @tag_value = @entry_hash[:id].to_s.gsub(/\s/, "_").gsub(/\W/, "")
          @check_box_id = "#{@object_name}_#{@param_name}_#{@tag_value}"
          yield(self)
        end
      end

      def check_box(options = nil)
        options = update_options({
            :id => @check_box_id, :type => 'checkbox', :value => @tag_value,
            :name => "#{@object_name}[#{@param_name}][]"
          }, @check_box_options, options)
        options[:checked] = 'checked' if @entry_hash[:select]
        @template.content_tag("input", nil, options)
      end

      def label(text = nil, options = nil)
        @template.content_tag("label", text || @entry_hash[:name],
          update_options({:for => @check_box_id}, options))
      end
    end

    module Base
      def check_box_group(object_name, method, options = nil, &block)
        object = (options || {})[:object] || instance_variable_get("@#{object_name}")
        builder = Builder.new(object, object_name, method, options, self)
        if block_given?
          yield(builder)
          return nil
        else
          result = ''
          builder.each do
            result << builder.check_box
            result << '&nbsp;'
            result << builder.label
            result << '&nbsp;'
          end
          return result.html_safe
        end
      end
    end

    module FormBuilder
      def check_box_group(method, options = nil, &block)
        @template.check_box_group(@object_name, method,
          (options || {}).merge(:object => @object), &block)
      end
    end
  end
end
