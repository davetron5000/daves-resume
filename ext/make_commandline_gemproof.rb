require 'commandline'

# Makes the inherited method not be so strict checking the app name
class CommandLine::Application
    class << self
        alias old_inherited inherited

        def inherited(child_class)
            @@appname = caller[0][/.*:/][0..-2]
            @@child_class = child_class
            normalized_appname = @@appname.gsub(/^.*\//,"");
            normalized_dollar0 = $0.gsub(/^.*\//,"");
            if normalized_appname == normalized_dollar0
                __set_auto_run
            end
        end
    end
end

