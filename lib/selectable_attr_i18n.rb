if defined?(I18n)
  module SelectableAttr
    class Enum
      def self.i18n_export
        result = {}
        instances.each do |instance|
          unless instance.i18n_scope
            # puts "no i18n_scope of #{instance.inspect}"
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

      def i18n_scope(*path)
        @i18n_scope = path unless path.empty?
        @i18n_scope
      end
    
      class Entry
        def name
          I18n.locale.nil? ? @name :
            @enum.i18n_scope.blank? ? @name :
            I18n.translate(key, :scope => @enum.i18n_scope, :default => @name)
        end
      end

    end
  end
end
