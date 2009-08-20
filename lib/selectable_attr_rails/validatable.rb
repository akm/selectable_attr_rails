require 'selectable_attr_rails'

module SelectableAttrRails
  module Validatable
    autoload :Base, 'selectable_attr_rails/validatable/base'
    autoload :Enum, 'selectable_attr_rails/validatable/enum'
  end
end
