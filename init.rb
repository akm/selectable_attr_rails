require 'selectable_attr'
require 'selectable_attr_rails'

module SelectableAttr
  class Enum
    include ::SelectableAttrRails::DbLoadable
  end
end

class ActiveRecord::Base
  include SelectableAttr::Base
end

class ActionView::Base
  include ::SelectableAttrRails::Helpers::SelectHelper::Base
  include ::SelectableAttrRails::Helpers::CheckBoxGroupHelper::Base
  include ::SelectableAttrRails::Helpers::RadioButtonGroupHelper::Base
end

class ActionView::Helpers::FormBuilder
  include ::SelectableAttrRails::Helpers::SelectHelper::FormBuilder
  include ::SelectableAttrRails::Helpers::CheckBoxGroupHelper::FormBuilder
  include ::SelectableAttrRails::Helpers::RadioButtonGroupHelper::FormBuilder
end
