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
      json["pages"][0]["traineritems"].each do |key|
        cmd = "mkdir audio/#{learn_language}"
        Kernel.system(cmd)
        cmd = "wget http://media.babbel.com/sound/#{key["sound_id"]}.mp3 -O audio/#{learn_language}/#{key["l1_text"]}.mp3"
        Kernel.system(cmd)
      end

    end

  end

end

downloader = OrganOfBaam::Downloader.new
downloader.get_json_files

