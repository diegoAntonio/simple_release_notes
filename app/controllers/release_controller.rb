class ReleaseController < ApplicationController
  unloadable

  before_filter :authorize
  def index
  	@tag_versions = Version.all.order(:created_on).all.map { |ver| [ver.name, ver.id] };
  end


  def generate_release
  	@selected_version = Version.where(:id =>  params[:version_id]).first
  	document_name = 'Release_Notes_' + @selected_version.name + '.odt'
    path = "#{Rails.public_path}/plugin_assets/simple_release_notes/template"
    template = path + '/' + 'template_consenso.odt'
    time = Time.now

  	@issues = Issue.where(:fixed_version_id => @selected_version.id)

    @evol_issues = @issues.select { |issue| issue.tracker.name == 'Evolutivas' }
    @corrective_issues = @issues.select { |issue| issue.tracker.name == 'Corretivas' }

    report = ODFReport::Report.new(template) do |r|
      r.add_field  :VERSION_NAME, @selected_version.name
      r.add_field  :RELEASE_DATE, time.strftime("%d/%m/%Y")
      r.add_field  :PRODUCT_NAME, params[:product]
      r.add_field  :TARGET_ENV, params[:environment]

      r.add_table("evol_table", @evol_issues, :header=>true) do |t|
        t.add_column(:RM_EVOL_ID,:id || "")
        t.add_column(:RM_EVOL_DESCRIPTION,:description || "")
      end


      r.add_table("corrective_table", @corrective_issues, :header=>true) do |t|
        t.add_column(:RM_CORRE_ID, :id || "")
        t.add_column(:RM_CORRE_DESCRIPTION,:description || "") 
      end

    end


    send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
                              disposition: 'attachment',
                              filename: document_name
  end
end