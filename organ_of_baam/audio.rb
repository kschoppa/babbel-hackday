module OrganOfBaam

  class Audio

    ROOT_AUDIO_DIR = "#{Dir.pwd}/audio"

    def initialize(audio_start_note)
      @audio_start_note = audio_start_note
      @audio_threads = {}
    end

    def import(learn_language)
      @learn_language_audio_dir = "#{ROOT_AUDIO_DIR}/#{learn_language}"
      Dir.chdir(@learn_language_audio_dir)
      @file_names = Dir.glob("*.mp3")
    end

    def start_playback(note)
      audio_index = note - (@audio_start_note)
      path = "#{@learn_language_audio_dir}/#{@file_names[audio_index]}".gsub(" ", "\\ ")
      cmd = "afplay #{path}"
      puts "Start audio playback #{cmd}"

      @audio_threads[note] = {}
      @audio_threads[note][:cmd] = cmd
      @audio_threads[note][:thread] = Thread.new do
        Kernel.system(cmd)
      end
    end

    def stop_playback(note)
      puts "Stop audio playback"
      uid = Process.uid
      Thread.kill(@audio_threads[note][:thread])
      pids = `pgrep -n afplay -u #{uid}`.split("\n")

      pids.each do |pid|
        Process.kill("TERM", pid.to_i)
      end
    end

  end

end
