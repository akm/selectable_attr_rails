module SelectableAttrRails
  module DbLoadable
    def update_by(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options = {:when => :first_time}.update(options)
      @sql_to_update = block_given? ? block : args.first
      @update_timing = options[:when]
      self.extend(InstanceMethods) unless respond_to?(:update_entries)
    end
    
    module Entry
      attr_accessor :name_from_db
      def name
        @name_from_db || super
      end
    end
    
    module InstanceMethods
      def entries
        update_entries if must_be_updated?
        @entries
      end
      
      def must_be_updated?
        return false if @update_timing == :never
        return true if @update_timing == :everytime
      end
      
      def update_entries
        unless @original_entries
          @original_entries = @entries.dup
          @original_entries.each do |entry|
            entry.extend(SelectableAttr::DbLoadable::Entry)
          end
        end
        records = nil
        if @sql_to_update.respond_to?(:call)
          records = @sql_to_update.call
        else
          @connection ||= ActiveRecord::Base.connection
          records = @connection.select_rows(@sql_to_update)
        end
        
        new_entries = []
        records.each do |r|
          if entry = @original_entries.detect{|entry| entry.id == r.first}
            entry.name_from_db = r.last unless r.last.blank?
            new_entries << entry
          else
            entry = SelectableAttr::Enum::Entry.new(self, r.first, "entry_#{r.first}".to_sym, r.last)
            new_entries << entry
          end
        end
        @original_entries.each do |entry|
          unless new_entries.include?(entry)
            entry.name_from_db = nil
            new_entries << entry if entry.defined_in_code
          end
        end
        @entries = new_entries
      end
    end
    
  end
end
