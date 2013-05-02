
class ThPartOfSpeech < ActiveRecord::Base
    attr_accessible :name, :abbr
    self.table_name = 'th_part_of_speech'
    self.primary_key = :th_part_of_speech_id

end
