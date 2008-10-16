require 'yaml'
require 'resume'
require 'fileutils'
include FileUtils
# Serializes a resume to/from YAML
class Serializer

    # Loads the resume artifacts from the given directory
    def Serializer.load(dir)
        if (!File.exists?(dir))
            raise "#{dir} doesn't exist"
        end

        resume = Resume::Resume.new
        resume.core = File.open( "#{dir}/resume.yaml" ) { |yf| YAML::load( yf ) } if File.exists?("#{dir}/resume.yaml")
        resume.skills = File.open( "#{dir}/skills.yaml" ) { |yf| YAML::load( yf ) } if File.exists?("#{dir}/skills.yaml")
        resume.experience = read(dir,"experience");
        resume.education = read(dir,"education");
        resume.references = read(dir,"references");
        resume.samples = read(dir,"samples");
        return resume
    end

    def Serializer.read(dir,base_name)
        list = Array.new
        Dir.glob("#{dir}/#{base_name}_*.yaml") do |file|
            list << File.open( file ) { |yf| YAML::load( yf ) }
        end
        list
    end

    # Stores the resume artifacts to the given directory.
    def Serializer.store(dir,resume)
        if File.exists?(dir)
            rm(Dir.glob("#{dir}/*.yaml"))
        else
            mkdir(dir)
        end
        File.open("#{dir}/resume.yaml",'w') { |out| YAML::dump(resume.core,out) }
        dump(dir,"experience",resume.experience)
        dump(dir,"education",resume.education)
        dump(dir,"reference",resume.references)
        dump(dir,"samples",resume.samples)
        File.open("#{dir}/skills.yaml",'w') { |out| YAML::dump(resume.skills,out) }
    end

    def Serializer.dump(dir,base_name,items)
        if (items && !items.empty?)
            count = 1
            items.each() do |item|
                filename = base_name + "_"
                if (item.respond_to? :name)
                    filename += item.name.gsub(/\//,"_").gsub(/\s/,"_")
                else
                    filename += count.to_s
                end
                filename += ".yaml"
                File.open("#{dir}/#{filename}",'w') { |out| YAML::dump(item,out) }
                count += 1
            end
        end
    end
end
