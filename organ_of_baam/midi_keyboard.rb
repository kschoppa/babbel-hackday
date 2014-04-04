require 'unimidi'
require 'pry'

module OrganOfBaam

  class MidiKeyboard

    START_NOTE            = 36
    ABORT_NOTE            = 72
    LEARN_LANGUAGES       = %w( DAN DEU ENG FRA IND ITA NLD NOR POL POR SPA SWE TUR )
    LEARN_LANGUAGES_KEYS  = (START_NOTE..START_NOTE+LEARN_LANGUAGES.size).to_a
    DEVICE_NAME           = "Egosys MIDIMATE II"

    def initialize
      @learn_language = LEARN_LANGUAGES[0]
    end

    def listen
      read_audio_files
      initialize_input_device
    end

    private

    def read_audio_files
      @audio = OrganOfBaam::Audio.new(START_NOTE + LEARN_LANGUAGES_KEYS.size)
      @audio.import(@learn_language)
    end

    def initialize_input_device
      @input = UniMIDI::Input.list.detect {|i| i.name == DEVICE_NAME }

      abort("Error: Device not connected") unless @input
      read_from_input_device
    end

    def read_from_input_device
      @input.open do |i|

        while(true) do
          midi = i.gets.first
          note = midi[:data][1]
          status = midi[:data][2]

          if LEARN_LANGUAGES_KEYS.include?(note.to_i)
            switch_learn_language(note) if status > 0
          elsif note.to_i == ABORT_NOTE
            abort("Bye Bye")
          else
            if status > 0
              @audio.start_playback(note)
            else
              @audio.stop_playback(note)
            end
          end
        end

      end
    end

    def switch_learn_language(note)
      @learn_language = LEARN_LANGUAGES[note - START_NOTE]
      @audio.import(@learn_language)
      puts "*** Switched to #{@learn_language} ***"
    end

  end

end
