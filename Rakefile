$: << "lib"
$: << "ext"
$: << "conf"

require 'rake/clean'
require 'rake/rdoctask'
require "resume"
require "format/markdown"
require "format/richtext"
require "serializer"
require "conf"
require "erb"
include Resume

SCAFFOLD_DIR = "scaffold"

CLEAN.include RESUME_MARKDOWN
CLEAN.include RESUME_RTF
CLOBBER.include SCAFFOLD_DIR

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
    rd.rdoc_files.include("ext/**/*.rb")
end

resume = nil
serializer = Serializer.new
serializer.core_to_use=CORE_TO_USE

task :read_resume do |t|
    resume = serializer.load(RESUME_YAML)
end

def configure_formatter(formatter)
    formatter.achievement_filter = ACHIEVEMENT_FILTER
end

task :rtf => :read_resume do |t|
    formatter = Format::RTFFormat.new(resume)
    configure_formatter formatter
    formatter.to_file(RESUME_RTF)
end

task :markdown => :read_resume do |t|
    template = ""
    File.open("templates/Markdown.erb") do |input|
        input.readlines.each() do |line|
            template += line
        end
    end
    markdown_template = ERB.new(template)
    markdown = markdown_template.result(resume.get_binding)
    File.open(RESUME_MARKDOWN,'w') do |file|
        file.puts markdown
    end
end

desc "Updates the README.markdown for GitHub with my resume"
task :readme => :markdown do |t|
    cp(RESUME_MARKDOWN, "README.markdown")
end

task :word => :rtf do |t|
    cp(RESUME_RTF,"Resume_of_David_Copeland.doc")
end

desc "Blows away and creates #{SCAFFOLD_DIR}, containg sample YAML for your resume"
task :scaffold do |t|
    puts ARGV
    rm_rf SCAFFOLD_DIR
    mkdir SCAFFOLD_DIR
    resume = Resume::Resume.scaffold
    serializer.store(SCAFFOLD_DIR,resume)
    puts "Rename #{SCAFFOLD_DIR}/ to the directory of your choice, then edit your resume"
end
task :default => [:word, :readme]
