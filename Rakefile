$: << "lib"
$: << "ext"

require 'rake/clean'
require 'rake/rdoctask'
require "resume"
require "format/markdown"
require "format/richtext"
require "serializer"
include Resume

RESUME_RTF = "resume.rtf"
RESUME_MARKDOWN = "resume.markdown"
SCAFFOLD_DIR = "scaffold"

CLEAN.include RESUME_MARKDOWN
CLEAN.include RESUME_RTF
CLOBBER.include SCAFFOLD_DIR

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
    rd.rdoc_files.include("ext/**/*.rb")
end

resume = nil

task :read_resume do |t|
    resume = Serializer.load("resume_dir")
end

task :rtf => :read_resume do |t|
    formatter = Format::RTFFormat.new(resume)
    formatter.to_file(RESUME_RTF)
end

task :markdown => :read_resume do |t|
    formatter = Format::MarkdownFormat.new(resume)
    formatter.to_file(RESUME_MARKDOWN)
end

task :readme => :markdown do |t|
    cp(RESUME_MARKDOWN, "README.markdown")
end

task :scaffold do |t|
    puts ARGV
    rm_rf "scaffold"
    mkdir "scaffold"
    resume = Resume::Resume.scaffold
    Serializer.store("scaffold",resume)
end
task :default => [:rtf, :markdown]
