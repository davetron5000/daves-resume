$: << "lib"
$: << "ext"
$: << "conf"

require 'rake/clean'
require 'rake/rdoctask'
require "resume"
require "serializer"
require "conf"
require "erb"
include Resume

SCAFFOLD_DIR = "scaffold"

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

def format(type,resume,file_to_make_copy=nil)
    template = ""
    File.open("templates/#{type}.erb") do |input|
        input.readlines.each() do |line|
            template += line
        end
    end
    type_template = ERB.new(template)
    type_data = type_template.result(resume.get_binding)
    file_name = RESUME_BASE + "." + type.downcase
    File.open(RESUME_BASE + "." + type.downcase,'w') do |file|
        file.puts type_data
    end
    cp(file_name,file_to_make_copy) if file_to_make_copy
    file_name
end

task :rtf => :read_resume do |t|
    format("RTF",resume,"Resume_of_David_Copeland.doc")
end

task :web => :read_resume do |t|
    format("HTML",resume)
end

task :markdown => :read_resume do |t|
    format("Markdown",resume,"README.markdown")
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
task :default => [:rtf, :web, :markdown]
