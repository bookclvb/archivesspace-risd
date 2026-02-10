require 'i18n'
require 'aspace_i18n'
require 'yaml_tools'

module CustomLocales
  @@locales_main = ASUtils.find_locales_directories("#{AppConfig[:locale]}.yml").first
  @@locales_enums = ASUtils.find_locales_directories(File.join("enums", "#{AppConfig[:locale]}.yml")).first
  @@plugin_main_combined = File.join(File.dirname(File.dirname(__FILE__)), 'locales', "#{AppConfig[:locale]}-combined.yml")
  @@plugin_enums_combined = File.join(File.dirname(File.dirname(__FILE__)), 'locales', "enums", "#{AppConfig[:locale]}-combined.yml")

  def self.create_combined
    plugin_main = File.join(File.dirname(File.dirname(__FILE__)), 'locales', "#{AppConfig[:locale]}.yml")

    if (File.exists?(plugin_main))
      combiner = YAMLTools::Combiner.new
      output = combiner.combine_files(@@locales_main, plugin_main)
      File.write(@@plugin_main_combined, output)
    end

    plugin_enums = File.join(File.dirname(File.dirname(__FILE__)), 'locales', "enums", "#{AppConfig[:locale]}.yml")

    if (File.exists?(plugin_enums))
      combiner = YAMLTools::Combiner.new
      output = combiner.combine_files(@@locales_enums, plugin_enums)
      File.write(@@plugin_enums_combined, output)
    end
  end

  def self.load_combined
    if (File.exists?(@@plugin_main_combined)) || (File.exists?(@@plugin_enums_combined))
      # Remove any existing paths from our locales directory
      new_load_path = I18n.load_path.reject { |p| p.match /custom_locales\/locales\// }

      if (File.exists?(@@plugin_main_combined))
        locales_main_index = new_load_path.index(@@locales_main)

        if (!locales_main_index.nil?) then
          new_load_path = new_load_path.insert(locales_main_index + 1, @@plugin_main_combined)
        else
          new_load_path = new_load_path << @@plugin_main_combined
        end
      end

      if (File.exists?(@@plugin_enums_combined))
        locales_main_enums_index = new_load_path.index(@@locales_enums)
        if (!locales_main_enums_index.nil?) then
          new_load_path = new_load_path.insert(locales_main_enums_index + 1, @@plugin_enums_combined)
        else
          new_load_path = new_load_path << @@plugin_enums_combined
        end
      end

      # Note: Because of the way I18n handles loading of new additions, the load_path should be set with assignment (I18n.load_path = ...).
      I18n.load_path = new_load_path
    end
  end
end

module I18n
  class << self
    if I18n.respond_to?(:prioritize_plugins!)
      alias :prioritize_plugins_original! :prioritize_plugins!

      def prioritize_plugins!
        prioritize_plugins_original!
        CustomLocales.load_combined
      end
    end
  end
end
