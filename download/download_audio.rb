require 'rubygems'
require 'json'
require 'open-uri'

class DownloadBabbelAudio

  def get_json_files
    %w( DAN DEU ENG FRA IND ITA NLD NOR POL POR SPA SWE TUR ).each do | learn_language |
      file = File.open("packages/#{learn_language}.json","r")
      file = file.read
      file_output = JSON.parse(file)
      download_audio_files(file_output, learn_language)
    end
  end

  def download_audio_files(file_output, learn_language)
    file_output["pages"][0]["traineritems"].each do |key|
      key["sound_id"]
      key["l1_text"]
      create_dir = "mkdir audio/#{learn_language}"
      Kernel.system(create_dir)
      save_file_in_dir = "wget http://media.babbel.com/sound/#{key["sound_id"]}.mp3 -O audio/#{learn_language}/#{key["l1_text"]}.mp3"
      Kernel.system(save_file_in_dir)
    end

  end

end

audio = DownloadBabbelAudio.new
audio.get_json_files
