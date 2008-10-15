module Resume
# The core elemens of the resume
class ResumeCore
    # Contact info, such as name and address
    attr_accessor :contact_info
    # Headline statement (String)
    attr_accessor :headline
    # Summary of qualifications (String)
    attr_accessor :summary
end

# The entire resume
class Resume
    # a ResumeCore object
    attr_accessor :core
    # Array of Job objects
    attr_accessor :experience
    # A SkillSet
    attr_accessor :skills
    # Array of Education objects
    attr_accessor :education
    # Array of Reference objects
    attr_accessor :references
    # Array of Sample objects
    attr_accessor :samples

    def initialize
        @samples = Array.new
        @references = Array.new
        @education = Array.new
        @experience = Array.new
    end
end

# A sample of work, avaiable via the internet
class Sample
    attr_accessor :name
    attr_accessor :url
    # a of SkillSet of the skills demonstrated by this sample
    attr_accessor :skills
end
# Represents a personal reference
class Reference
    attr_accessor :name
    attr_accessor :phone
    attr_accessor :email
    attr_accessor :company
    attr_accessor :relationship
end

# Represents all skills
class SkillSet

    @@categories = {
        :languages=> "Languages",
        :apis=> "APIs",
        :tools=>"Tools",
        :databases=>"Databases",
        :operating_systems=>"OSes"
    }

    @@category_order = [
        :languages,
        :apis,
        :tools,
        :databases,
        :operating_systems,
    ]
    # Hash of category to skill objects
    attr_accessor :skills
end

# Represents a skill, such as "Java"
class Skill
    attr_accessor :name
    attr_accessor :experience_level
    attr_accessor :years_experience

    def initialize(name,exp)
        @name = name
        @experience_level = exp
    end

    def <=>(other_skill)
        if (other_skill.experience_level == @experience_level)
            return @years_experience <=> other_skill.years_experience
        else
            return 1 if (@experience_level == :expert)
            return 1 if (@experience_level == :intermediate && other_skill.experience_level == :novice)
            return -1;
        end
    end

    def to_s
        @name
    end
end

# Represents a degree earned or other college-type educational experience
class Education
    attr_accessor :name
    attr_accessor :degree
    attr_accessor :year_graduated
    attr_accessor :major
    attr_accessor :other_info
end

# Contact information, such as name, email, address
class ContactInfo
    attr_accessor :name
    attr_accessor :email
    # An Address object
    attr_accessor :address
    attr_accessor :phone
end

class Address
    attr_accessor :street
    attr_accessor :city
    attr_accessor :state
    attr_accessor :zip
end

# A job that you had, i.e. a time working for a company
class Job
    # Name of the company
    attr_accessor :name
    attr_accessor :date_range
    # Location, e.g. San Francisco, VA
    attr_accessor :location
    # Array of Position objects
    attr_accessor :positions 
end

# A position held within a job
class Position
    # Job title
    attr_accessor :title
    attr_accessor :date_range
    # Description of the position's requirements
    attr_accessor :description
    # Array of achievements
    attr_accessor :achievments
end

class DateRange
    attr_accessor :start_date
    attr_accessor :end_date

    def <=>(other_range)
        return @start_date <=> other_range.start_date
    end
end
end
