class Resume::Position

    attr_accessor :filter_config

    def filter_achievements!
        counts = Hash.new
        developer_not_architect = Array.new
        filtered = achievements.select() do |a|
            if !a.tags || a.tags.empty?
                filter_config.include_untagged_achievements
            else
                a.tags.each() { |t| counts[t] = counts[t] ? counts[t] += 1 : 1 }
                developer_not_architect << a if (!a.tags.include? filter_config.primary_tag) && (a.tags.include? filter_config.alt_tag)
                if (a.tags.include? :major)
                    true
                else
                    ! ((a.tags & filter_config.achievement_tags).empty?)
                end
            end
        end
        if !counts[filter_config.primary_tag]
            filtered = filtered | developer_not_architect
        end
        if filtered.size < filter_config.min_achievements
            needed = filter_config.min_achievements - filtered.size()
            needed.times() { |i| filtered << achievements[i] if achievements[i] && !filtered.include?(achievements[i]) }
        elsif filtered.size > filter_config.max_achievements
            filtered = filtered.select() do |a|
                if !a.tags || a.tags.empty?
                    true
                else
                    !a.tags.include?(:minor)
                end
            end
        end
        @achievements = filtered
    end
end
