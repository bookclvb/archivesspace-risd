require 'asutils'
require_relative '../plugins_zip.rb'

class AtlasHostingController < ApplicationController

  set_access_control  "view_repository" => [:index],
                      "administer_system" => [:plugins, :download_plugin]

  def index
    if AppConfig.has_key?(:atlas_hosting_info_url) && AppConfig[:atlas_hosting_info_url]
        @atlas_hosting_info_url = AppConfig[:atlas_hosting_info_url];
    else
        @atlas_hosting_info_url = "https://atlas-info.azurewebsites.net/ArchivesSpace.html"
    end
  end

  def plugins
    @plugins = AppConfig[:plugins]
  end

  def download_plugin
    generator = PluginsZip.new

    if params[:name].blank?
      @output_file = generator.write_all
      filename = "plugins.zip"
    else
      plugin_name = params[:name]

      if !AppConfig[:plugins].include?(plugin_name)
        Rails.logger.info("Atlas Hosting") { "Invalid plugin requested: #{plugin_name}" }
        redirect_to :action => "plugins"
        return
      end

      @output_file = generator.write(plugin_name)
      filename = "#{plugin_name}.zip"
    end

    send_file(@output_file.path, :type => 'application/zip', :disposition => 'attachment', filename: filename)

    PluginsZip.clean_tempfiles
  end
end
