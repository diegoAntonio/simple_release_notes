# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/release_notes' => 'release#index'

get '/gerar_release' => 'release#generate_release', as: 'gerar_release'