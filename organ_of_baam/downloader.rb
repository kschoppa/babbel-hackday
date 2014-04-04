require 'rubygems'
require 'json'
require 'open-uri'

module OrganOfBaam

  class Downloader

    LEARN_LANGUAGES = %w( DAN DEU ENG FRA IND ITA NLD NOR POL POR SPA SWE TUR )

    def get_json_files
      LEARN_LANGUAGES.each do |learn_language|
        file = File.open("packages/#{learn_language}.json", "r")
        json = JSON.parse(file.read)
        download_audio_files(json, learn_language)
      end
    end

    def download_audio_files(json, learn_language)
      Dir.mkdir("audio/#{learn_language}") unless File.exists?("audio/#{learn_language}")

      json["pages"][0]["traineritems"].each_with_index do |key, index|
        prefix = "%02d" % index
        cmd = "wget http://media.babbel.com/sound/#{key["sound_id"]}.mp3 -O audio/#{learn_language}/0#{prefix}-#{key["sound_id"]}.mp3"
        Kernel.system(cmd)
      end

      Dir
    end

  end

end

downloader = OrganOfBaam::Downloader.new
downloader.get_json_files

