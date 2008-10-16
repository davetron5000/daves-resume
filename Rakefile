$: << "lib"
$: << "ext"

require 'rake/clean'
require 'rake/rdoctask'
require "resume"
require "markdown"
require "richtext"
require "serializer"
include Resume

RESUME_RTF = "resume.rtf"
RESUME_MARKDOWN = "resume.markdown"

CLEAN.include RESUME_MARKDOWN
CLEAN.include RESUME_RTF

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
    rd.rdoc_files.include("ext/**/*.rb")
end

resume = nil

task :read_resume do |t|
    resume = Serializer.load("resume_dir")
end

task :rtf => :read_resume do |t|
    File.open('resume.rtf','w') {|file| file.write(resume.to_rtf.to_rtf)}
end

task :markdown => :read_resume do |t|
    File.open("resume.markdown",'w') { |fp| fp.puts resume.to_markdown() }
end

task :readme => :markdown do |t|
    cp(RESUME_MARKDOWN, "README.markdown")
end

task :default => [:rtf, :markdown]
