require 'json'

class CustomLocalesController < ApplicationController
  set_access_control "view_repository" => [:index]

  def index
    locales_combined = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales', "#{AppConfig[:locale]}-combined.yml")
    locales_modified = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales', "#{AppConfig[:locale]}.yml")
    enums_combined = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales/enums', "#{AppConfig[:locale]}-combined.yml")
    enums_modified = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales/enums', "#{AppConfig[:locale]}.yml")

    @locales_combined_exists = File.exists?(locales_combined)
    @locales_modified_exists = File.exists?(locales_modified)
    @enums_combined_exists = File.exists?(enums_combined)
    @enums_modified_exists = File.exists?(enums_modified)
    @debug_enabled = ENV.has_key?('CUSTOM_LOCALES_DEBUG')

    case params[:file]
    when 'combined_locales'
      return get_combined_locales
    when 'modified_locales'
      return get_modified_locales
    when 'combined_enums'
      return get_combined_enums
    when 'modified_enums'
      return get_modified_enums
    when 'all'
      return get_all_translations
    end
  end

  def get_combined_locales
    locales_combined = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales', "#{AppConfig[:locale]}-combined.yml")
    send_file(locales_combined, :type => 'text/yaml', :disposition => 'attachment', filename: "#{AppConfig[:locale]}-locales-combined.yml")
  end

  def get_modified_locales
    locales_modified = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales', "#{AppConfig[:locale]}.yml")
    send_file(locales_modified, :type => 'text/yaml', :disposition => 'attachment', filename: "#{AppConfig[:locale]}-locales-modified.yml")
  end

  def get_combined_enums
    enums_combined = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales/enums', "#{AppConfig[:locale]}-combined.yml")
    send_file(enums_combined, :type => 'text/yaml', :disposition => 'attachment', filename: "#{AppConfig[:locale]}-enums-combined.yml")
  end

  def get_modified_enums
    enums_modified = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'locales/enums', "#{AppConfig[:locale]}.yml")
    send_file(enums_modified, :type => 'text/yaml', :disposition => 'attachment', filename: "#{AppConfig[:locale]}-enums-modified.yml")
  end

  def get_all_translations
    translations = I18n.backend.send(:translations)[AppConfig[:locale]]
    send_data(translations.to_json, :type => 'application/json', :disposition => 'attachment', filename: "#{AppConfig[:locale]}-all.json")
  end
end
