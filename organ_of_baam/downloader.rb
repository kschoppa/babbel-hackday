require 'rubygems'
require 'json'
require 'open-uri'

module OrganOfBaam

  class Downloader

    LEARN_LANGUAGES = %w( DAN DEU ENG FRA IND ITA NLD NOR POL POR SPA SWE TUR )

    def get_json_files
      LEARN_LANGUAGES.each do |learn_language|
        %w(packages packages_loveletters).each do |folder_name|
          if File.exists?("#{folder_name}/#{learn_language}.json")
            file = File.open("#{folder_name}/#{learn_language}.json", "r")
            json = JSON.parse(file.read)
            download_audio_files(json, learn_language, "audio_#{folder_name}")
          end
        end
      end
    end

    def download_audio_files(json, learn_language, audio_folder_name)
      Dir.mkdir("#{audio_folder_name}/#{learn_language}") unless File.exists?("#{audio_folder_name}/#{learn_language}")

      json["pages"][0]["traineritems"].each_with_index do |key, index|
        prefix = "%02d" % index
        cmd = "wget http://media.babbel.com/sound/#{key["sound_id"]}.mp3 -O #{audio_folder_name}/#{learn_language}/0#{prefix}-#{key["sound_id"]}.mp3"
        Kernel.system(cmd)
      end

      Dir
    end

  end

end

downloader = OrganOfBaam::Downloader.new
downloader.get_json_files


