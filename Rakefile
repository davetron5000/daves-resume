require 'rake/clean'
require 'rake/rdoctask'

Rake::RDocTask.new do |rd|
    rd.rdoc_files.include("lib/**/*.rb")
end

desc 'Runs tests'
task :test do |t|
    $: << 'lib'
    $: << 'test'
#    require 'testTask.rb'
#    require 'testProject.rb'
#    Test::Unit::UI::Console::TestRunner.run(TC_testTask)
#    Test::Unit::UI::Console::TestRunner.run(TC_testProject)
#    Test::Unit::UI::Console::TestRunner.run(TC_testProjectDecompose)
end

task :clobber_coverage do
    rm_rf "coverage"
end

desc 'Measures test coverage'
task :coverage => :clobber_coverage do
    rcov = "rcov -Ilib"
    system("#{rcov} test/test*.rb")
    system("open coverage/index.html") if PLATFORM['darwin']
end

task :default => :test
task :clobber => :clobber_coverage
