$KCODE='u'

FIXTURES_ROOT = File.join(File.dirname(__FILE__), 'fixtures') unless defined?(FIXTURES_ROOT)

require 'rubygems'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'
require 'active_record/test_case'
require 'action_controller'
require 'action_view'

require 'selectable_attr'

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require File.join(File.dirname(__FILE__), '..', 'init')

require 'yaml'
config = YAML.load(IO.read(File.join(File.dirname(__FILE__), 'database.yml')))
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'debug.log'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])

load(File.join(File.dirname(__FILE__), 'schema.rb'))


def assert_hash(expected, actual)
  keys = (expected.keys + actual.keys).uniq
  keys.each do |key|
    assert_equal expected[key], actual[key], "unmatch value for #{key.inspect}"
  end
end

# http://d.hatena.ne.jp/nedate/20101004/1286183882
if defined?(Rcov)
  class Rcov::CodeCoverageAnalyzer
    def update_script_lines__
      if '1.9'.respond_to?(:force_encoding)
        SCRIPT_LINES__.each do |k,v|
          v.each { |src| src.force_encoding('utf-8') }
        end
      end
      @script_lines__ = @script_lines__.merge(SCRIPT_LINES__)
    end
  end
end
