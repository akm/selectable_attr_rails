require 'selectable_attr_rails/validatable'

module SelectableAttrRails
  module Validatable
    module Enum
      def validates_format_options
        @validates_format_options
      end
      def validates_format(options = nil)
        return @validates_format_options = nil if options == false
        @validates_format_options = options || {}
      end

    end
  end
end
