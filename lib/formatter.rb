require 'erb'
module Resume

    # Handles formatting the resume using ERB templates.
    # Create an instance of this class, then call a method named for your template.
    # In +templates_dir+, if a file is named Xyz.erb, formatter.Xyz will run the resume through
    # the template.  If an argument is passed to the method, the resulting file
    # will be copied to the file named by the argument.
    #
    #     formatter = Formatter.new(resume,"MyResume","/home/davec/templates")
    #     formatter.doc("DavesResume.doc")
    #
    # This will try to find +/home/davec/templates/doc.erb+ and use it to create your resume.  The
    # resulting file would be +MyResume.doc+ and that file would be copied to +DavesResume.doc+
    class Formatter
        TEMPLATES_DEFAULT = File.expand_path(File.dirname(__FILE__) + '/../templates') 
        # Create a new Formatter for a given resume
        #
        # +resume+:: The Resume object to format
        # +resume_name+:: The basename of the files that will be output
        # +templates_dir+:: location of your templates
        def initialize(resume,resume_name="resume",templates_dir=TEMPLATES_DEFAULT)
            @resume = resume
            @resume_name = resume_name
            @templates_dir = templates_dir
        end

        # Does the formatting based on the method name, if the template is found.  Case matters
        def method_missing(method,*args)
            type = method.to_s
            template_file = "#{@templates_dir}/#{type}.erb"
            if (File.exists? template_file)
                template = ""
                File.open(template_file) do |input|
                    input.readlines.each() do |line|
                        template += line
                    end
                end
                type_template = ERB.new(template)
                type_data = type_template.result(@resume.get_binding)
                file_name = @resume_name + "." + type.downcase
                File.open(@resume_name + "." + type.downcase,'w') do |file|
                    file.puts type_data
                end
                if args && !args.empty?
                    cp(file_name,args[0])
                end
            else
                raise "There is no template for #{type}"
            end
        end
    end
end
