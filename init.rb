Redmine::Plugin.register :simple_release_notes do
  name 'Simple Release Notes plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  menu :application_menu, :simple_release_notes, { :controller => 'release', :action => 'index' }, :caption => 'Release Notes'
end
