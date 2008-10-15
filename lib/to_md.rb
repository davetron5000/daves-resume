require "resume"
require "markdown"
require "serializer"

include Resume
resume = Serializer.load("resume_dir")
File.open("README.markdown",'w') { |fp| fp.puts resume.to_markdown() }
