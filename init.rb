Redmine::Plugin.register :simple_release_notes do
  name 'Simple Release Notes plugin'
  author 'Diego Antônio Ferreira'
  description 'A simple plugin for generate automatic Release Notes'
  version '0.0.1'
  url 'http://github.com/diegoAntonio/SimpleReleaseNotes'
  author_url 'http://github.com/diegoAntonio'
  menu :application_menu  , :simple_release_notes, { :controller => 'release', :action => 'index' }, :caption => 'Release Notes'
  permission :generate_release, :release => :index
  permission :gerar_release, :release => :generate_release
end
