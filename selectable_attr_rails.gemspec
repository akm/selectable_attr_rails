# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{selectable_attr_rails}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takeshi Akima"]
  s.date = %q{2009-01-27}
  s.description = %q{selectable_attr_rails makes possible to use selectable_attr in rails application}
  s.email = %q{akima@gmail.com}
  s.files = ["VERSION.yml", "lib/selectable_attr_rails", "lib/selectable_attr_rails/db_loadable.rb", "lib/selectable_attr_rails/helpers", "lib/selectable_attr_rails/helpers/abstract_selection_helper.rb", "lib/selectable_attr_rails/helpers/check_box_group_helper.rb", "lib/selectable_attr_rails/helpers/radio_button_group_helper.rb", "lib/selectable_attr_rails/helpers/select_helper.rb", "lib/selectable_attr_rails/helpers.rb", "lib/selectable_attr_rails/version.rb", "lib/selectable_attr_rails.rb", "spec/database.yml", "spec/debug.log", "spec/fixtures", "spec/introduction_spec.rb", "spec/schema.rb", "spec/selectable_attr_i18n_test.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/akm/selectable_attr_rails/}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{selectable_attr_rails makes possible to use selectable_attr in rails application}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
