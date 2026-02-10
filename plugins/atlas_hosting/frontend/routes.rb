ArchivesSpace::Application.routes.draw do
  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|
    scope prefix do
      match('/plugins/atlas_hosting/plugins/download' => 'atlas_hosting#download_plugin', :via => [:get])
      match('/plugins/atlas_hosting/plugins' => 'atlas_hosting#plugins', :via => [:get])
      match('/plugins/atlas_hosting' => 'atlas_hosting#index', :via => [:get])
    end
  end
end
