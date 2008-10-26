RESUME_YAML = 'resume_dir'
RESUME_RTF = "resume.rtf"
RESUME_MARKDOWN = "resume.markdown"
RESUME_HTML = "resume.html"
#PRIMARY_TAG = :developer
#ALT_TAG = :architect
#CORE_TO_USE = "developer"
PRIMARY_TAG = :architect
ALT_TAG = :developer
CORE_TO_USE = "techlead"
ACHIEVEMENT_TAGS = [ :lead, :pm, PRIMARY_TAG ]
INCLUDE_UNTAGGED_ACHIEVEMENTS = true
# Try to have at least this many
MIN_ACHIEVEMENTS = 3
# If more than this, try to trim some
MAX_ACHIEVEMENTS = 5

# Complex filter:
# - filters list based on tags in ACHIEVEMENT_TAGS
# - anything tagged as :major is included
# - if no :architect tags were present, includes all :developer tagged items
# - if list is too small, fills it in
# - if list is too big, trims anything tagged :minor
ACHIEVEMENT_FILTER = Proc.new do |achievements|
    counts = Hash.new
    developer_not_architect = Array.new
    filtered = achievements.select() do |a|
        if !a.tags || a.tags.empty?
            INCLUDE_UNTAGGED_ACHIEVEMENTS
        else
            a.tags.each() { |t| counts[t] = counts[t] ? counts[t] += 1 : 1 }
            developer_not_architect << a if (!a.tags.include? PRIMARY_TAG) && (a.tags.include? ALT_TAG)
            if (a.tags.include? :major)
                true
            else
                ! ((a.tags & ACHIEVEMENT_TAGS).empty?)
            end
        end
    end
    if !counts[PRIMARY_TAG]
        filtered = filtered | developer_not_architect
    end
    if filtered.size < MIN_ACHIEVEMENTS
        needed = MIN_ACHIEVEMENTS - filtered.size()
        needed.times() { |i| filtered << achievements[i] if achievements[i] && !filtered.include?(achievements[i]) }
    elsif filtered.size > MAX_ACHIEVEMENTS
        filtered = filtered.select() do |a|
            if !a.tags || a.tags.empty?
                true
            else
                !a.tags.include?(:minor)
            end
        end
    end
    filtered
end
