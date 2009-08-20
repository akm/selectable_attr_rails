require 'selectable_attr_rails/validatable'

module SelectableAttrRails
  module Validatable
    module Base
      def self.included(mod)
        mod.extend(ClassMethods)
        mod.instance_eval do
          alias :define_enum_without_validatable :define_enum
          alias :define_enum :define_enum_with_validatable
        end
      end

      module ClassMethods
        def define_enum_with_validatable(context)
          enum = context[:enum]
          if options = enum.validates_format_options
            options[:with] = Regexp.union(*enum.entries.map{|entry| /#{Regexp.escape(entry.id)}/})
            entry_format = options.delete(:entry_format) || '#{entry.name}'
            entries = enum.entries.map{|entry| instance_eval("\"#{entry_format}\"")}.join(', ')
            message = options.delete(:message) || 'is invalid, must be one of #{entries}'
            options[:message] = instance_eval("\"#{message}\"")
            validates_format_of(context[:attr], options)
          end
        end
      end


    end
  end
end


