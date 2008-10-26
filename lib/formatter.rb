module Resume
    class Formatter
        def initialize(resume,resume_name="resume",templates_dir="templates")
            @resume = resume
            @resume_name = resume_name
            @templates_dir = templates_dir
        end

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
