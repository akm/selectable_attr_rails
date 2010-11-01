require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "selectable_attr_rails"
    s.summary  = "selectable_attr_rails makes possible to use selectable_attr in rails application"
    s.description  = "selectable_attr_rails makes possible to use selectable_attr in rails application"
    s.email    = "akima@gmail.com"
    s.homepage = "http://github.com/akm/selectable_attr_rails/"
    s.authors  = ["Takeshi Akima"]
    s.add_dependency("activesupport", ">= 2.0.2")
    s.add_dependency("activerecord", ">= 2.0.2")
    s.add_dependency("actionpack", ">= 2.0.2")
    s.add_dependency("selectable_attr", ">= 0.3.11")
    s.add_development_dependency "rspec", ">= 1.3.1"
    s.add_development_dependency "sqlite3-ruby"
    s.add_development_dependency "rcov"
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "range_dsl #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
