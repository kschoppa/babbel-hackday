module OrganOfBaam

  class Audio

    ROOT_AUDIO_DIR              = "#{Dir.pwd}/audio_packages"
    ROOT_AUDIO_DIR_LOVELETTERS  = "#{Dir.pwd}/audio_packages_loveletters"

    def initialize(audio_start_note)
      @audio_start_note = audio_start_note
      @audio_threads = {}
    end

    def import(learn_language, mode)
      root_dir = mode == :numbers ? ROOT_AUDIO_DIR : ROOT_AUDIO_DIR_LOVELETTERS
      @learn_language_audio_dir = "#{root_dir}/#{learn_language}"
      Dir.chdir(@learn_language_audio_dir)
      @file_names = Dir.glob("*.mp3").sort
    end

    def start_playback(note, velocity)
      audio_index = note - (@audio_start_note)
      path = "#{@learn_language_audio_dir}/#{@file_names[audio_index]}".gsub(" ", "\\ ")
      pitch_factor = (velocity.to_f / 75.to_f)

      cmd = "play #{path} speed #{pitch_factor}"
      puts "Start audio playback #{cmd}"

      @audio_threads[note]= Thread.new do
        Kernel.system(cmd)
      end
    end

    def stop_playback(note)
      puts "Stop audio playback"
      uid = Process.uid
      Thread.kill(@audio_threads[note])
      pids = `pgrep -n play -u #{uid}`.split("\n")

      pids.each do |pid|
        Process.kill("TERM", pid.to_i)
      end
    end

  end

end
