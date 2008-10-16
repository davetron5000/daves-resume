require "resume"
require "markdown"
require "richtext"
require "serializer"

include Resume
resume = Serializer.load("resume_dir")
File.open("README.markdown",'w') { |fp| fp.puts resume.to_markdown() }

File.open('resume.rtf','w') {|file| file.write(resume.to_rtf.to_rtf)}
