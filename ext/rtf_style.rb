require 'rubygems'
require 'rtf'

include RTF

class ParagraphStyle
    alias :old_prefix :prefix
    attr_accessor :tab_stop
    def prefix(fonts,colours)
        new_text = StringIO.new
        text = old_prefix(fonts,colours)
        new_text << text
        if (@tab_stop)
            current_stop = @tab_stop
            10.times() do |n|
                current_stop += @tab_stop
                new_text << "\\tqr\\tx#{current_stop}"
            end
        end
        new_text.string.length > 0 ? new_text.string : nil
    end
end
