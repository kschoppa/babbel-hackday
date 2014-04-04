require 'unimidi'
require 'pry'

class OrganOfBaam

  START_NOTE = 36

  def initialize
    @threads = {}

    read_audio_files
    initialize_input_device
  end

  def read_audio_files
    @dir_name = "/Users/tweiss/Music/iTunes/iTunes Media/Music/Bonobo/Black Sands"
    Dir.chdir(@dir_name)
    @file_names = Dir.glob("*.m4a")
  end

  def initialize_input_device
    @input = UniMIDI::Input.list.detect {|i| i.name == "Egosys MIDIMATE II" }
  end

  def read_from_input_device
    @input.open do |i|

      loop do
        data = i.gets.first[:data]
        note = data[1]
        status = data[2]

        if status > 0
          start_audio_playback(note)
        else
          stop_audio_playback(note)
        end
      end

    end
  end

  def start_audio_playback(note)
    path = "#{@dir_name}/#{@file_names[note-START_NOTE]}".gsub(" ", "\\ ")
    cmd = "afplay #{path}"
    puts cmd
    @threads[note] = Thread.new do
      Kernel.system(cmd)
    end
  end

  def stop_audio_playback(note)
    Thread.kill(@threads[note])
    Process.kill("INT", Kernel.spawn("pgrep -f afplay"))
  end

end

organ = OrganOfBaam.new
organ.read_from_input_device
