if defined?(I18n)
  require 'selectable_attr'

  module SelectableAttr
    class Enum
      def self.i18n_export(enums = nil)
        enums ||= instances
        result = {}
        enums.each do |instance|
          unless instance.i18n_scope
            SelectableAttrRails.logger.debug("no i18n_scope of #{instance.inspect}")
            next
          end
          paths = instance.i18n_scope.dup
          current = result
          paths.each do |path|
            current = current[path.to_s] ||= {}
          end
          instance.entries.each do |entry|
            current[entry.key.to_s] = entry.name
          end
        end
        result
      end
    end
  end
end
