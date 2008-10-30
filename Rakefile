require 'rake/clean'
require 'rake/rdoctask'

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
    rd.rdoc_files.include("ext/**/*.rb")
end


task :rtf do |t|
    if (system("bin/dr-format -f RTF -r resume_dir -c techlead -n resume --filter position_filter"))
        cp("resume.rtf","Resume_Of_David_Copeland_TechLead.doc")
    else
        warn "Couldn't run dr-format"
    end
    if (system("bin/dr-format -f RTF -r resume_dir -c developer -n resume --filter position_filter"))
        cp("resume.rtf","Resume_Of_David_Copeland_Developer.doc")
    else
        warn "Couldn't run dr-format"
    end
end

task :markdown do |t|
    if (system("bin/dr-format -f Markdown -r resume_dir -c techlead -n resume --filter position_filter"))
        cp("resume.markdown","README.markdown")
    else
        warn "Couldn't run dr-format"
    end
end

task :default => [:rtf, :markdown]
