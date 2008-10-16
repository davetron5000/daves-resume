require 'rubygems'
require 'rtf'

include RTF

module Resume

    INCH = 1440

    H1 = CharacterStyle.new;
    H2 = CharacterStyle.new;
    H3 = CharacterStyle.new;
    H4 = CharacterStyle.new;
    LIST_ITEM = CharacterStyle.new
    LIST_DESCRIPTION = CharacterStyle.new
    SUPPLEMENTAL = CharacterStyle.new

    LIST_ITEM.font_size = 20
    LIST_ITEM.bold = true
    LIST_DESCRIPTION.font_size = 20
    SUPPLEMENTAL.font_size = 16
    H1.font_size = 40
    H1.bold = true
    H2.font_size = 36
    H2.bold = true
    H3.font_size = 24
    H3.bold = true
    H4.font_size = 20
    H4.bold = true

# The entire resume
class Resume
    def to_rtf
        style = DocumentStyle.new
        style.top_margin = INCH
        style.left_margin = INCH
        style.right_margin = INCH
        style.bottom_margin = INCH
        style.paper = Paper::LETTER
        rtf = Document.new(Font.new(Font::SWISS,"Garamond"),style)
        @core.contact_info.to_rtf(rtf)

        heading_style = CharacterStyle.new
        heading_style.font_size = 24
        heading_style.bold = true
        rtf.paragraph(heading_style) << @core.headline
        rtf.paragraph << " "
        rtf.paragraph(H2) << "Summary"

        summary_style = ParagraphStyle.new
        summary_style.left_indent = 200
        summary_style.right_indent = 200
        summary_style.justification = ParagraphStyle::FULL_JUSTIFY
        rtf.paragraph(summary_style) do |n|
            font = CharacterStyle.new
            font.italic = true
            font.font_size = 22
            n.apply(font) do |n2|
                n2 << @core.summary
            end
        end

        if (@skills)
            rtf.paragraph(H2) << "Skills"
            @skills.to_rtf(rtf)
        end

        rtf.paragraph(H2) << "Experience"
        @experience.sort() { |a,b| a.date_range <=> b.date_range}.each() do |exp|
            exp.to_rtf(rtf)
        end
        rtf.paragraph(H2) << "Education"
        @education.sort() { |a,b| b.year_graduated <=> a.year_graduated }.each() do |edu|
            edu.to_rtf(rtf)
        end
        rtf
    end
end

class Sample
    def to_rtf
        "**not implemented**"
    end
end

# Represents a personal reference
class Reference
    def to_rtf
        "**not implemented**"
    end
end

class SkillSet
    def to_rtf(rtf)
        novice_skills = Array.new
        skills.each() do |k,v|
            novice_skills = novice_skills | v.select() { |x| x.experience_level == :novice }.sort().reverse()
        end
        @@category_order.each() do |s|
            rtf.table(1,2,INCH,5 * INCH) do |table|
                skills = @skills[s]
                if skills && !skills.empty?
                    category_to_rtf(skills,@@categories[s],table)
                end
            end
        end
        rtf.table(1,2,2 * INCH,4 * INCH) do |table|
            if !novice_skills.empty?
                table[0][0].apply(LIST_DESCRIPTION) { |n| n << "Some experience with:" }
                table[0][1].apply(LIST_DESCRIPTION) { |n| n << novice_skills.sort().join(", ") }
            end
        end
    end

    def category_to_rtf(skills,label,table)
        table[0][0].apply(LIST_ITEM) { |n| n << "#{label}:" }
        table[0][1].apply(LIST_DESCRIPTION) { |n| n << skills.select() { |x| x.experience_level != :novice }.sort().reverse().join(", ") }
    end
end

class Education
    def to_rtf(rtf)

        rtf.paragraph(H3) << "#{name} - #{degree}, #{major}, #{year_graduated}"
        if (@other_info)
            rtf.paragraph(SUPPLEMENTAL) << "#{other_info}"
        end
        rtf
    end
end

class ContactInfo
    def to_rtf(rtf)
        rtf.paragraph(H1) << @name
        rtf.table(4,2,1440,1440 * 3) do |table|
            table[0][0].apply(LIST_ITEM) { |n| n << "Address:" }
            table[0][1].apply(LIST_DESCRIPTION) { |n| n << @address.street }
            table[1][0] << " "
            table[1][1].apply(LIST_DESCRIPTION) { |n| n << "#{@address.city}, #{@address.state} #{address.zip}" }
            table[2][0].apply(LIST_ITEM) { |n| n << "Phone:" }
            table[2][1].apply(LIST_DESCRIPTION) { |n| n << "#{phone}" }
            table[3][0].apply(LIST_ITEM) { |n| n << "Email:" }
            table[3][1].apply(LIST_DESCRIPTION) { |n| n << "#{email}" }
        end
    end
end
class Job
    def to_rtf(rtf)

        rtf.paragraph(H3) << "#{name} (#{location})"
        if (!@positions || @positions.size() != 1)
            rtf.paragraph << "#{date_range.to_rtf}"
        end

        positions.each() do |p|
            p.to_rtf(rtf)
        end
        rtf
    end
end

class Position
    def to_rtf(rtf)
        rtf.paragraph(H4) << "#{title}"
        rtf.paragraph << "#{date_range.to_rtf}"
        rtf.paragraph << "#{description}"
        achievments.each() do |a|
            rtf.paragraph << "#{a}\n"
        end
        rtf
    end
end

class DateRange
    def to_rtf
        if (@end_date)
            return "#{start_date.month}/#{start_date.year} - #{end_date.month}/#{start_date.year}"
        else
            return "#{start_date.month}/#{start_date.year} - present"
        end
    end
end
end
