require "format/formatter"

module Resume
module Format

# This formats the resume in Markdown
class MarkdownFormat < Format

    def initialize(resume)
        @markdown = StringIO.new
        @resume = resume
    end

    # Formats and writes the output to the give filename
    def to_file(file_name)
        format
        File.open(file_name,'w') {|file| file.write(@markdown.string) }
    end

    def output_contact
        @markdown << "# #{@resume.core.contact_info.name}\n\n+ **Address:** "
        @markdown << "#{@resume.core.contact_info.address.city}, #{@resume.core.contact_info.address.state} #{@resume.core.contact_info.address.zip}\n"
        @markdown << "+ **Phone:** #{@resume.core.contact_info.phone}\n" + "+ **Email:** #{@resume.core.contact_info.safe_email}\n"
        @markdown << "\n" +  "* * *"
    end

    def add_section_heading(label)
        @markdown << "\n" +  "## #{label}\n"
    end

    def output_headline
        @markdown << "\n" +  @resume.core.headline
    end

    def output_summary
        add_section_heading("Summary")
        @markdown << "\n" +  @resume.core.summary
    end

    def output_skills
        if (@resume.skills)
            add_section_heading("Skills")
            @markdown << "\n"
            output_skillset(@resume.skills.skills)
            @markdown << "\n"
        end

    end

    def output_skillset(skills)
        SkillSet.category_order.each() do |s|
            skillset_category_to_markdown(s,SkillSet.categories[s],skills)
        end
        novice_skills = Array.new
        skills.each() do |k,v|
            novice_skills = novice_skills | v.select() { |x| x.experience_level == :novice }.sort().reverse()
        end
        if !novice_skills.empty?
            @markdown << "+ *Some experience with*:" + novice_skills.join(", ")
        end
    end

    def skillset_category_to_markdown(category,label,skills)
        these_skills = skills[category]
        if (these_skills && !these_skills.empty?)
            @markdown << "+ **#{label}**: "
            @markdown << these_skills.select() { |x| x.experience_level != :novice }.sort().reverse().join(", ")
            @markdown << "\n"
        end
    end

    def output_experience(exp)
        @markdown << "### #{exp.name} (#{exp.location})\n"
        if (!exp.positions || exp.positions.size() != 1)
            @markdown << "_#{exp.date_range.to_s}_\n\n"
        end

        exp.positions.each() do |p|
            output_position(p)
            @markdown << "\n"
        end
        @markdown
    end
    def output_position(position)
        @markdown << "#### #{position.title}\n_#{position.date_range.to_s}_\n\n"
        @markdown << "_Description:_ #{position.description}\n\n"
        @markdown << "Key Achievements:\n\n"
        position.achievements.each() do |a|
            @markdown << "+ #{a}\n"
        end
    end

    def output_education(edu)
        @markdown << "### #{edu.name} - #{edu.degree}, #{edu.major}, #{edu.year_graduated}"
        if (edu.other_info)
            @markdown << "\n#{edu.other_info}"
        end
            @markdown << "\n" +  "\n"
    end

    def output_sample(sample)
        @markdown << "* [#{sample.name}](#{sample.url})\n"
    end
end
end
end
