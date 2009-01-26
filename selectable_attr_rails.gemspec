Gem::Specification.new do |spec|
  spec.name     = "selectable_attr_rails"
  spec.version  = "0.0.3"
  spec.date     = "2009/01/26"
  spec.summary  = "selectable_attr_rails makes possible to use selectable_attr in rails application"
  spec.description  = "selectable_attr_rails makes possible to use selectable_attr in rails application"
  spec.email    = "akima@gmail.com"
  spec.authors  = ["Takeshi Akima"]
  spec.homepage = "http://github.com/akm/selectable_attr_rails/"
  spec.has_rdoc = false

  spec.add_dependency("activerecord", ">= 2.1.0")
  spec.add_dependency("selectable_attr", ">= 0.0.3")

  spec.files  = [
    "MIT-LICENSE", "README",
    "Rakefile", "init.rb", "install.rb", "uninstall.rb",
    "lib/selectable_attr_rails/db_loadable.rb",
    "lib/selectable_attr_rails/helpers/abstract_selection_helper.rb",
    "lib/selectable_attr_rails/helpers/check_box_group_helper.rb",
    "lib/selectable_attr_rails/helpers/radio_button_group_helper.rb",
    "lib/selectable_attr_rails/helpers/select_helper.rb",
    "lib/selectable_attr_rails/helpers.rb",
    "lib/selectable_attr_rails/version.rb",
    "lib/selectable_attr_rails.rb",
    "spec/introduction_spec.rb",
    "spec/schema.rb",
    "spec/selectable_attr_i18n_test.rb",
    "spec/spec_helper.rb"]
end
