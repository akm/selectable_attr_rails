require 'rake'
require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr_rails', 'version')

Gem::Specification.new do |spec|
  spec.name     = "selectable_attr_rails"
  spec.version  = SelectableAttrRails::VERSION
  spec.date     = Time.now.strftime("%Y/%m/%d %H:%M:%S")
  spec.summary  = "selectable_attr_rails makes possible to use selectable_attr in rails application"
  spec.email    = "akima@gmail.com"
  spec.authors  = ["Takeshi Akima"]
  spec.homepage = "http://github.com/akm/selectable_attr_rails/"
  spec.has_rdoc = false

  spec.add_dependency("activerecord", ">= 2.1.0")
  spec.add_dependency("selectable_attr", SelectableAttrRails::VERSION)

  spec.files         = FileList['Rakefile', 'bin/*', '*.rb', '{lib,test}/**/*.{rb}', 'tasks/**/*.{rake}'].to_a
  # spec.require_path  = "lib"
  # spec.requirements  = ["none"]
  # spec.autorequire = 'selectable_attr_rails' # autorequire is deprecated
end
