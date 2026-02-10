require 'i18n'
require_relative '../locales/locales.rb'

CustomLocales.load_combined

frontend_plugin_locales = File.join(File.dirname(__FILE__), 'locales', "#{AppConfig[:locale]}.plugin.yml")
I18n.load_path = I18n.load_path << frontend_plugin_locales

ArchivesSpace::Application.extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))
