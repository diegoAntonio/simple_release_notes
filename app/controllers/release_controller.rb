class ReleaseController < ApplicationController
  unloadable

  def index
  	@tag_versions = Version.all.order(:created_on).all.map { |ver| [ver.name, ver.id] };
  end


  def generate_release
  	@selected_version = Version.where(:id =>  params[:version_id])[0]
  	document_name = 'Release_Notes_' + @selected_version.name + '.docx'

  	@issues = Issue.where(:fixed_version_id => @selected_version.id)


	

	render docx: 'template_release', filename: document_name

  end

end
