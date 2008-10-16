require 'rubygems'
require 'rtf'
require 'rtf_style'
require 'format/formatter'

include RTF

module Resume
module Format

# Formats the resume as RTF
class RTFFormat <  Format

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
    H1.font = Font.new(Font::SWISS,"Helvetica")
    H1.font_size = 40
    H1.bold = true
    H2.font = H1.font
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

    # Formats the resume via format and outputs the results to the named file
    def to_file(file)
        format
        File.open(file,'w') {|file| file.write(rtf.to_rtf)}
    end

    def add_heading(rtf,style,label)
        rtf.paragraph(HEAD_INDENT) do |p|
            p.apply(style) { |n| n << label }
        end
    end

    attr_reader :rtf

    def initialize(resume)
        @resume = resume
        style = DocumentStyle.new
        style.top_margin = INCH
        style.left_margin = INCH + QUARTER_INCH
        style.right_margin = INCH
        style.bottom_margin = INCH
        style.paper = Paper::LETTER
        @rtf = Document.new(Font.new(Font::SWISS,"Georgia"),style)

        footer_style = CharacterStyle.new
        footer_style.font_size = 16
        footer_style.italic = true
        footer = FooterNode.new(@rtf)
        @rtf.footer=footer
        @rtf.footer.apply(footer_style) { |n| n << "Resume of #{resume.core.contact_info.name}" }

    end

    def output_contact
        info = @resume.core.contact_info
        add_heading(rtf,H1,info.name)
        indent = ParagraphStyle.new
        #rtf.paragraph(indent) << @address.street
        rtf.paragraph(indent) << "#{info.address.city}, #{info.address.state} #{info.address.zip}" 
        rtf.paragraph(indent) << "#{info.phone}" 
        rtf.paragraph(indent) << "#{info.email}"
        rtf.paragraph << " "
    end


    def output_headline
        heading_style = CharacterStyle.new
        heading_style.font_size = 24
        heading_style.bold = true
        rtf.paragraph(heading_style) << @resume.core.headline
        rtf.paragraph << " "
    end

    def add_section_heading(label)
        add_heading(rtf,H2,label)
    end

    def output_summary
        add_section_heading("Summary")

        summary_style = ParagraphStyle.new
        rtf.paragraph(summary_style) do |n|
            font = CharacterStyle.new
            font.italic = true
            font.font_size = 22
            n.apply(font) do |n2|
                n2 << @resume.core.summary
            end
        end
    end

    def output_skills
        if (@resume.skills)
            add_section_heading("Skills")
            output_skillset
        end
    end

    def output_experience(exp)
        indent = ParagraphStyle.new
        indent.left_indent = (-1 * (QUARTER_INCH / 2))
        rtf.paragraph(indent) do |p|
            p.apply(H3) do |n| 
                n << "#{exp.name} (#{exp.location}) " 
                if exp.positions && !exp.positions.empty?
                    n.italic() << " #{exp.date_range.to_s}"
                end
            end
        end

        exp.positions.each() do |p|
            output_position(p,exp.positions.size() > 1)
        end
    end
    def output_position(p,include_date)

        if (include_date)
            rtf.paragraph(H4).underline().italic() << "#{p.title} (#{p.date_range.to_s})"
        else
            rtf.paragraph(H4).underline().italic() << "#{p.title}"
        end
        rtf.paragraph do |para|
            para.italic().apply(TEN_POINT) { |n| n << "#{p.description}" }
        end
        p.achievements.each() do |a|
            add_bullet(rtf,a)
        end
    end

    def output_education(edu)
        rtf.paragraph(H3) << "#{edu.name} - #{edu.degree}, #{edu.major}, #{edu.year_graduated}" 
        if (edu.other_info)
            rtf.paragraph(SUPPLEMENTAL) do |p|
                p.apply(SUPPLEMENTAL_TEXT) { |n| n << "#{edu.other_info}" }
            end
        end
    end

    def output_skillset
        novice_skills = Array.new
        @resume.skills.skills.each() do |k,v|
            novice_skills = novice_skills | v.select() { |x| x.experience_level == :novice }.sort().reverse()
        end
        SkillSet.category_order.each() do |s|
            rtf.table(1,2,INCH,5 * INCH) do |table|
                skills = @resume.skills.skills[s]
                if skills && !skills.empty?
                    skillset_category_to_rtf(skills,SkillSet.categories[s],table)
                end
            end
        end
        rtf.table(1,2,INCH,5 * INCH) do |table|
            if !novice_skills.empty?
                table[0][0].apply(LIST_DESCRIPTION) { |n| n << "Exposure to:" }
                table[0][1].apply(LIST_DESCRIPTION) { |n| n << novice_skills.sort().join(", ") }
            end
        end
    end

    def skillset_category_to_rtf(skills,label,table)
        table[0][0].apply(LIST_ITEM) { |n| n << "#{label}:" }
        table[0][1].apply(LIST_DESCRIPTION) { |n| n << skills.select() { |x| x.experience_level != :novice }.sort().reverse().join(", ") }
    end
end
end
end
