$: << "lib"
$: << "ext"
$: << "conf"

require 'rake/clean'
require 'rake/rdoctask'
require 'resume'
require 'formatter'
require 'serializer'
require 'conf'
require 'erb'

include Resume

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
    rd.rdoc_files.include("ext/**/*.rb")
end

serializer = Serializer.new
serializer.core_to_use=CORE_TO_USE
formatter = nil

task :read_resume do |t|
    formatter = Formatter.new(serializer.load(RESUME_YAML),RESUME_BASE)
end

task :rtf => :read_resume do |t|
    formatter.RTF("Resume_of_David_Copeland.doc")
end

task :web => :read_resume do |t|
    formatter.HTML
end

task :markdown => :read_resume do |t|
    formatter.Markdown("README.markdown")
end

task :default => [:rtf, :web, :markdown]
