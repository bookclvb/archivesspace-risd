require_relative './plugins_zip.rb'

ArchivesSpace::Application.extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

Rails.application.config.after_initialize do
  PluginsZip.clean_tempfiles
end
