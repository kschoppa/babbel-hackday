require './organ_of_baam/audio'
require './organ_of_baam/midi_keyboard'

keyboard = OrganOfBaam::MidiKeyboard.new
keyboard.listen
