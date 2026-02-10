# Custom Locales

Note: while the mentioned paths contain "en.yml", the actual value will be the value of the `locale` setting in the ArchivesSpace configuration (ex. "es.yml").

The file `locales/en.yml` will override values in `/archivesspace/locales/en.yml` and the file `locales/enums/en.yml` will override values in `/archivesspace/locales/enums/en.yml`. The backend, frontend, indexer, and public will all load these overrides directly after the default ArchivesSpace values.

The overrides are performed by combining the default file with the override file, writing the result to the plugin directory, and adding it to the [I18n](https://guides.rubyonrails.org/i18n.html) load path.
The `frontend/locales/en.yml` and `public/locales/en.yml` files will be loaded as outlined in [Customizing text in ArchivesSpace](https://archivesspace.github.io/tech-docs/customization/locales.html).

## Installation

Run the plugin initialization script to install the required gem:

```shell
./scripts/initialize-plugin.sh custom_locales
```
