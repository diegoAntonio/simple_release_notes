Redmine::Plugin.register :simple_release_notes do
  name 'Simple Release Notes plugin'
  author 'Diego Antônio Ferreira'
  description 'A simple plugin for generate automatic Release Notes'
  version '1.2.0'
  url 'http://github.com/diegoAntonio/SimpleReleaseNotes'
  author_url 'http://github.com/diegoAntonio'
  menu :project_menu  , :simple_release_notes, { :controller => 'release', :action => 'index' }, :caption => 'Release Notes'
 
 project_module :simple_release_notes do
    permission :generate_releases, {:release => [:index, :generate_release]}, :require => :member
 end

end
