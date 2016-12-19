class ReleaseController < ApplicationController
  unloadable

  def index
  	@tag_versions = Version.all.order(:created_on).all.map { |ver| [ver.name, ver.id] };
  end


  def generate_release

  	puts "cheguei"
  	put "cheguei 2"
  end

end
