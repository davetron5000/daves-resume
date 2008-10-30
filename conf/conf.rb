RESUME_YAML = 'resume_dir'
RESUME_BASE = 'resume'
CORE_TO_USE = "techlead"

require 'resume'
require 'yaml'

tech_lead_config = Resume::ResumeConfig.new
tech_lead_config.primary_tag = :architect
tech_lead_config.alt_tag = :developer
tech_lead_config.achievement_tags = [:lead, :pm, :architect]
tech_lead_config.include_untagged_achievements = true
tech_lead_config.min_achievements = 3
tech_lead_config.max_achievements = 3
tech_lead_config.core_name = 'techlead'

developer_config = Resume::ResumeConfig.new
developer_config.primary_tag = :developer
developer_config.alt_tag = :architect
developer_config.achievement_tags = [:lead, :pm, :developer]
developer_config.include_untagged_achievements = true
developer_config.min_achievements = 3
developer_config.max_achievements = 3
developer_config.core_name = 'developer'
#File.open("dev.yaml",'w') { |out| YAML::dump(developer_config,out) }
#File.open("techlead.yaml",'w') { |out| YAML::dump(tech_lead_config,out) }
