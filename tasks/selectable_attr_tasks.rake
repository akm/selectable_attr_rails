require 'yaml'
require 'yaml_waml'

namespace :i18n do
  namespace :selectable_attr do
    task :load_all_models => :environment do
      Dir.glob(File.join(RAILS_ROOT, 'app', 'models', '**', '*.rb')) do |file_name|
        require file_name
      end
    end
    
    desc "Export i18n resources for selectable_attr entries"
    task :export => :"i18n:selectable_attr:load_all_models" do
      obj = {I18n.locale => SelectableAttr::Enum.i18n_export}
      puts YAML.dump(obj)
    end
  end
end
