module ReleaseHelper

	config.after_initialize do
		properties_path = "#{Rails.public_path}/plugin_assets/simple_release_notes/properties/properties.yaml"
   	 	@properties = YAML.load_file(properties_path)
	end


	def get_propertie(propertie_name)
		@properties[propertie_name]
	end
end
