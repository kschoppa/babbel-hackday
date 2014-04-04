require 'rubygems'
require 'json'
require 'open-uri'

class DownloadBabbelAudio

def initialize

end

def json_file
  %w(DAN DEU FRA IND ITA NLD NOR POL POR SPA SWE TUR ).each do | learn_lanugage |
    file = File.open("/Users/rafalsztajer/babbel-hackday/packages/#{learn_lanugage}.json","r")
    file = file.read
    file_output = JSON.parse(file)
    download_audio_files(file_output, learn_lanugage)
  end
end

def download_audio_files(file_output, learn_lanugage)
  file_output["pages"][0]["traineritems"].each do |key|
    key["sound_id"]
    key["l1_text"]
    create_dir = "mkdir #{learn_lanugage}"
    Kernel.system(create_dir)
    save_file_in_dir = "wget http://media.babbel.com/sound/#{key["sound_id"]}.mp3 -O #{learn_lanugage}/#{key["l1_text"]}.mp3"
    Kernel.system(save_file_in_dir)
  end

end

end

audio = DownloadBabbelAudio.new
audio.json_file
