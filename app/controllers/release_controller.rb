class ReleaseController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :only => :index

  def index
    project_default = get_propertie("id_project_default")
  	@tag_versions = Version.where(:status => 'open', :project_id => project_default).
                            order(:created_on).all.map { |ver| [ver.name, ver.id] };
  end


  def generate_release
  	@selected_version = Version.where(:id =>  params[:version_id]).first
  	document_name = 'Release_Notes_' + @selected_version.name + '.odt'
    path = "#{Rails.public_path}/plugin_assets/simple_release_notes/template"
    template = path + '/' + 'template_consenso.odt'
    time = Time.now
    is_private_false = 0
    custom_issues_lst = nil
    custom_msg = ' '
    parameter_custom_issues = params[:custom_issues]

    id_pronta_pra_homolog = get_propertie("id_pronta_pra_homolog")
    id_concluida = get_propertie("id_concluida")
    id_concluido = get_propertie("id_concluido")
    id_pronto = get_propertie("id_pronto")

    @valid_issues_states = [id_pronta_pra_homolog, id_concluida, id_concluido, id_pronto];    

  	@issues = Issue.where(:fixed_version_id => @selected_version.id, 
                          :status_id => @valid_issues_states,
                          :is_private => is_private_false)
                          .order("tracker_id","id")

      custom_issues_lst = Issue.where(:id => parameter_custom_issues)

      if !custom_issues_lst.empty?
        custom_issues_lst.each do |issue|
          issue.subject = issue.subject + "*"
        end
        
        @issues.push(*custom_issues_lst)
        custom_msg = '* Significa RM\'s entregues de forma parcial.'
      end

    report = ODFReport::Report.new(template) do |r|
      r.add_field  :VERSION_NAME, @selected_version.name
      r.add_field  :RELEASE_DATE, time.strftime("%d/%m/%Y")
      r.add_field  :PRODUCT_NAME, params[:product]
      r.add_field  :TARGET_ENV,  params[:environment]
    
      r.add_table("rms_table", @issues, :header=>true) do |t|
        t.add_column(:RM_ID, :id || "")
        t.add_column(:RM_SUBJECT, :subject || "") 
        t.add_column(:RM_TYPE) {|issue| "#{issue.tracker.name}" }
        r.add_field  :CUSTOM_MSG, custom_msg
      end
    end

    send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
                              disposition: 'attachment',
                              filename: document_name
  end
end

private

def find_project
   @project = Project.find(params[:project_id])
end

def get_propertie(propertie_name)
    properties_path = "#{Rails.public_path}/plugin_assets/simple_release_notes/properties/properties.yaml"
    properties = YAML.load_file(properties_path)
    properties[propertie_name]
end