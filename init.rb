require 'selectable_attr'

module SelectableAttr
  class Enum
    include SelectableAttr::DbLoadable
  end
end

class ActiveRecord::Base
  include SelectableAttr::Base
end

class ActionView::Base
  include SelectableAttr::Helpers::SelectHelper::Base
  include SelectableAttr::Helpers::CheckBoxGroupHelper::Base
  include SelectableAttr::Helpers::RadioButtonGroupHelper::Base
end

class ActionView::Helpers::FormBuilder
  include SelectableAttr::Helpers::SelectHelper::FormBuilder
  include SelectableAttr::Helpers::CheckBoxGroupHelper::FormBuilder
  include SelectableAttr::Helpers::RadioButtonGroupHelper::FormBuilder
end
