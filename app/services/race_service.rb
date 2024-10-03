class RaceService
  attr_accessor :error
  def initialize(race)
    @race = race
    @error = ''
  end

  def update_positions(student_ids, positions)
    student_ids.each_with_index do |student_id, index|
      student_race = StudentRace.find_by_id(student_id.to_i, @race.id)
      unless student_race
        error = I18n.t('race.not_found')
        return false
      end
      student_race.position = positions[index]
      student_race.save if student_race
    end
  end
end
