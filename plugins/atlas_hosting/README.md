# Atlas Hosting Plugin

This plug-in adds a system menu `Atlas Hosting` which when clicked will display a view containing a section of a specified web page.

## Installation

Install the atlas_hosting plug-in by placing it in the `plugins` directory and adding it to the ArchivesSpace configuration (`config/config.rb`). For example:

    AppConfig[:plugins] = ['local', 'hello_world', 'atlas_hosting']

If the AppConfig[:plugins] property is commented out, the defaults are being used so may opt to add the plugin by appending to the defaults instead. For example:

    AppConfig[:plugins] << 'atlas_hosting'

Please see [ArchivesSpace Plug-ins](https://github.com/archivesspace/archivesspace/blob/master/plugins/PLUGINS_README.md) for more information on plug-ins.

## Configuration

### URL

Although not normally needed, the URL for the page that is displayed may be configured by adding a value to the ArchivesSpace configuration (`config/config.rb`).

    AppConfig[:atlas_hosting_info_url] = "https://atlas-info.azurewebsites.net/ArchivesSpace.html"

If a value is not supplied, then the default value will be used. The default value is [https://atlas-info.azurewebsites.net/ArchivesSpace.html](https://atlas-info.azurewebsites.net/ArchivesSpace.html).

