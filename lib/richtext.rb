require 'rubygems'
require 'rtf'
require 'rtf_style.rb'

include RTF

module Resume

    QUARTER_INCH = 360
    HALF_INCH = QUARTER_INCH * 2
    INCH = HALF_INCH * 2

    H1 = CharacterStyle.new;
    H2 = CharacterStyle.new;
    H3 = CharacterStyle.new;
    H4 = CharacterStyle.new;
    LIST_ITEM = CharacterStyle.new
    LIST_DESCRIPTION = CharacterStyle.new
    SUPPLEMENTAL_TEXT = CharacterStyle.new
    SUPPLEMENTAL = ParagraphStyle.new
    HEAD_INDENT = ParagraphStyle.new
    BULLET_ITEM = ParagraphStyle.new

    BULLET_ITEM.left_indent = QUARTER_INCH
    BULLET_ITEM.first_line_indent = -1 * QUARTER_INCH
    BULLET_ITEM.tab_stop = QUARTER_INCH

    HEAD_INDENT.left_indent = (-1 * QUARTER_INCH)
    LIST_ITEM.font_size = 20
    LIST_ITEM.bold = true
    LIST_DESCRIPTION.font_size = 20
    SUPPLEMENTAL.left_indent = QUARTER_INCH
    SUPPLEMENTAL_TEXT.font_size = 20
    SUPPLEMENTAL_TEXT.italic = true
    H1.font_size = 40
    H1.bold = true
    H2.font_size = 36
    H2.bold = true
    H3.font_size = 26
    H3.bold = true
    H4.font_size = 24
    H4.bold = true

    TEN_POINT = CharacterStyle.new
    TEN_POINT.font_size = 20

    def add_bullet(rtf,text)
        rtf.paragraph(BULLET_ITEM) do |p|
            # This seems to make a bullet in MS word
            p.apply(TEN_POINT) { |n| n << "¥ \t#{text}" }
        end
    end

    def add_heading(rtf,style,label)
        rtf.paragraph(HEAD_INDENT) do |p|
            p.apply(style) { |n| n << label }
        end
    end
# The entire resume
class Resume
    def to_rtf
        style = DocumentStyle.new
        style.top_margin = INCH
        style.left_margin = INCH + QUARTER_INCH
        style.right_margin = INCH
        style.bottom_margin = INCH
        style.paper = Paper::LETTER
        rtf = Document.new(Font.new(Font::SWISS,"Georgia"),style)
        @core.contact_info.to_rtf(rtf)
        rtf.paragraph << " "

        heading_style = CharacterStyle.new
        heading_style.font_size = 24
        heading_style.bold = true
        rtf.paragraph(heading_style) << @core.headline
        rtf.paragraph << " "
        add_heading(rtf,H2,"Summary")

        summary_style = ParagraphStyle.new
        rtf.paragraph(summary_style) do |n|
            font = CharacterStyle.new
            font.italic = true
            font.font_size = 22
            n.apply(font) do |n2|
                n2 << @core.summary
            end
        end

        if (@skills)
            add_heading(rtf,H2,"Skills")
            @skills.to_rtf(rtf)
        end

        add_heading(rtf,H2,"Experience")
        @experience.sort() { |a,b| b.date_range <=> a.date_range}.each() do |exp|
            exp.to_rtf(rtf)
        end
        add_heading(rtf,H2,"Education")
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
            rtf.paragraph(SUPPLEMENTAL) do |p|
                p.apply(SUPPLEMENTAL_TEXT) { |n| n << "#{other_info}" }
            end
        end
        rtf
    end
end

class ContactInfo
    def to_rtf(rtf)
        add_heading(rtf,H1,@name)
        indent = ParagraphStyle.new
        #rtf.paragraph(indent) << @address.street
        rtf.paragraph(indent) << "#{@address.city}, #{@address.state} #{address.zip}" 
        rtf.paragraph(indent) << "#{phone}" 
        rtf.paragraph(indent) << "#{email}"
    end
end
class Job
    def to_rtf(rtf)

        indent = ParagraphStyle.new
        indent.left_indent = (-1 * (QUARTER_INCH / 2))
        rtf.paragraph(indent) do |p|
            p.apply(H3) do |n| 
                n << "#{name} (#{location}) " 
                if @positions && !@positions.empty?
                    n.italic() << " #{date_range.to_s}"
                end
            end
        end

        positions.each() do |p|
            p.to_rtf(rtf,positions.size() > 1)
        end
        rtf
    end
end

class Position
    def to_rtf(rtf,include_date)
        if (include_date)
            rtf.paragraph(H4).underline().italic() << "#{title} (#{date_range.to_s})"
        else
            rtf.paragraph(H4).underline().italic() << "#{title}"
        end
        rtf.paragraph do |p|
            p.italic().apply(TEN_POINT) { |n| n << "#{description}" }
        end
        achievements.each() do |a|
            add_bullet(rtf,a)
        end
        rtf
    end
end
end
