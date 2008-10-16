module Resume
module Format

# This provides hooks for formatting the resume in a consistent way, despite the 
# actual output format
class Format

    def format
        output_contact
        output_headline
        output_summary
        output_skills

        add_section_heading("Experience")
        @resume.experience.sort() { |a,b| b.date_range <=> a.date_range}.each() do |exp|
            output_experience(exp)
        end
        add_section_heading("Education")
        @resume.education.sort() { |a,b| b.year_graduated <=> a.year_graduated }.each() do |edu|
            output_education(edu)
        end

        if respond_to? :output_sample
            @resume.samples.each() do |sample|
                add_section_heading("Samples")
                output_sample(sample)
            end
        end
    end

    def output_skills
        add_section_heading("Skills")
    end
end

end
end
