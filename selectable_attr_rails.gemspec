require 'rake'
require File.join(File.dirname(__FILE__), 'lib', 'selectable_attr_rails', 'version')

Gem::Specification.new do |spec|
  spec.name = "selectable_attr_rails"
  spec.version = SelectableAttrRails::VERSION
  spec.platform = "ruby"
  spec.summary = "selectable_attr_rails makes possible to use selectable_attr in rails application"
  spec.author = "Takeshi Akima"
  spec.email = "akima@gmail.com"
  spec.homepage = "http://d.hatena.ne.jp/akm"
  spec.rubyforge_project = "rubybizcommons"
  spec.has_rdoc = false

  spec.add_dependency("activerecord", ">= 2.1.0")
  spec.add_dependency("selectable_attr", SelectableAttrRails::VERSION)

  spec.files = FileList['Rakefile', 'bin/*', '*.rb', '{lib,test}/**/*.{rb}', 'tasks/**/*.{rake}'].to_a
  spec.require_path = "lib"
  spec.requirements = ["none"]
  # spec.autorequire = 'selectable_attr_rails' # autorequire is deprecated
  
  # bin_files = FileList['bin/*'].to_a.map{|file| file.gsub(/^bin\//, '')}
  # spec.executables = bin_files
  
  # spec.default_executable = 'some_executable.sh'
end
