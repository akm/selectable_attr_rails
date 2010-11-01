# -*- coding: utf-8 -*-
require 'selectable_attr'

module SelectableAttrRails
  autoload :Helpers, 'selectable_attr_rails/helpers'
  autoload :DbLoadable, 'selectable_attr_rails/db_loadable'
  autoload :Validatable, 'selectable_attr_rails/validatable'

  class << self
    def logger
      @logger ||= Logger.new(STDERR)
    end
    def logger=(value)
      @logger = value
    end

    def add_features_to_active_record
      ActiveRecord::Base.module_eval do
        include ::SelectableAttr::Base
        include ::SelectableAttrRails::Validatable::Base
      end
      SelectableAttr::Enum.module_eval do
        include ::SelectableAttrRails::DbLoadable
        include ::SelectableAttrRails::Validatable::Enum
      end
      logger.debug("#{self.name}.add_features_to_active_record")
    end

    def add_features_to_action_view
      ActionView::Base.module_eval do
        include ::SelectableAttrRails::Helpers::SelectHelper::Base
        include ::SelectableAttrRails::Helpers::CheckBoxGroupHelper::Base
        include ::SelectableAttrRails::Helpers::RadioButtonGroupHelper::Base
      end
      ActionView::Helpers::FormBuilder.module_eval do
        include ::SelectableAttrRails::Helpers::SelectHelper::FormBuilder
        include ::SelectableAttrRails::Helpers::CheckBoxGroupHelper::FormBuilder
        include ::SelectableAttrRails::Helpers::RadioButtonGroupHelper::FormBuilder
      end
      logger.debug("#{self.name}.add_features_to_action_view")
    end

    def add_features_to_rails
      add_features_to_active_record
      add_features_to_action_view
    end

    def setup
      logger = defined?(Rails) ? Rails.logger : ActiveRecord::Base.logger
      self.logger = logger
      SelectableAttr.logger = logger if SelectableAttr.respond_to?(:logger=) # since 0.3.11
      add_features_to_rails
    end
  end

end
