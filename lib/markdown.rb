module Resume

# The entire resume
class Resume
    def to_markdown
        markdown = @core.contact_info.to_markdown
        markdown += "\n" +  "* * *"
        markdown += "\n" +  @core.headline
        markdown += "\n" +  "## Summary"
        markdown += "\n" +  @core.summary

        if (@skills)
            markdown += "\n" +  "## Skills"
            markdown += "\n" +  @skills.to_markdown
            markdown += "\n"
        end

        markdown += "\n" +  "## Experience"
        @experience.sort() { |a,b| a.date_range<=> b.date_range}.each() do |exp|
            markdown += "\n" +  exp.to_markdown
        end
        markdown += "\n" +  "## Education"
        @education.sort() { |a,b| b.year_graduated <=> a.year_graduated }.each() do |edu|
            markdown += "\n" +  edu.to_markdown
            markdown += "\n" +  "\n"
        end
        markdown
    end
end

class Sample
    def to_markdown
        "**not implemented**"
    end
end

# Represents a personal reference
class Reference
    def to_markdown
        "**not implemented**"
    end
end

# Represents all skills
class SkillSet

    def to_markdown
        markdown = ""
        @@category_order.each() do |s|
            markdown += category_to_markdown(s,@@categories[s])
        end
        novice_skills = Array.new
        skills.each() do |k,v|
            novice_skills = novice_skills | v.select() { |x| x.experience_level == :novice }.sort().reverse()
        end
        if !novice_skills.empty?
            markdown += "+ *Some experience with*:" + novice_skills.join(", ")
        end
    end

    def category_to_markdown(category,label)
        markdown = ""
        skills = @skills[category]
        if (skills && !skills.empty?)
            markdown += "+ **#{label}**: "
            markdown += skills.select() { |x| x.experience_level != :novice }.sort().reverse().join(", ")
            markdown += "\n"
        end
        markdown
    end
end

class Education
    def to_markdown
        markdown = "### #{name} - #{degree}, #{major}, #{year_graduated}"
        if (@other_info)
            markdown += "\n#{other_info}"
        end
        markdown
    end
end

class ContactInfo
    def to_markdown
        "# #{name}\n\n+ **Address:**#{address.to_markdown}\n" + "+ **Phone:** #{phone}\n" + "+ **Email:** #{email}\n"
    end
end

class Address
    def to_markdown
        "#{street}\n#{city}, #{state} #{zip}"
    end
end

class Job
    def to_markdown
        markdown = "### #{name} (#{location})\n"
        if (!@positions || @positions.size() != 1)
            markdown += "_#{date_range.to_markdown}_\n\n"
        end

        positions.each() do |p|
            markdown += p.to_markdown
            markdown += "\n"
        end
        markdown
    end
end

class Position
    def to_markdown
        markdown = "#### #{title}\n_#{date_range.to_markdown}_\n\n#{description}\n\n"
        achievments.each() do |a|
            markdown += "+ #{a}\n"
        end
        markdown
    end
end

class DateRange
    def to_markdown
        if (@end_date)
            return "#{start_date.month}/#{start_date.year} - #{end_date.month}/#{start_date.year}"
        else
            return "#{start_date.month}/#{start_date.year} - present"
        end
    end
end
end
