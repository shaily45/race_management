class StudentRace
  include SessionInfo
  extend SessionInfo
  attr_accessor :race_id, :student_id, :lane, :position

  def initialize(race_id, student_id, lane, position = nil)
    @race_id = race_id
    @student_id = student_id
    @lane = lane
    @position = position
  end

  def save
    session[:student_races] ||= []
    existing_record = session[:student_races].find do |sr|
      sr['race_id'] == race_id && sr['student_id'] == student_id
    end

    if existing_record
      existing_record['lane'] = lane
      existing_record['position'] = position
    else
      session[:student_races].push({
        'race_id' => race_id,
        'student_id' => student_id,
        'lane' => lane,
        'position' => position
      })
    end
    self
  end

  def destroy
    session[:student_races]&.reject! do |sr|
      sr['race_id'] == race_id && sr['student_id'] == student_id
    end
  end

  def race
    Race.find_by_id(race_id)
  end

  def student
    Student.find_by_id(student_id)
  end

  def self.all
    student_races = self.session[:student_races]
    student_races.map do |sr|
      new(sr['race_id'], sr['student_id'], sr['lane'], sr['position'])
    end
  end

  def self.find_by_id(student_id, race_id)
    student_race_data = self.session[:student_races]&.find do |sr|
      sr['student_id'] == student_id && sr['race_id'] == race_id
    end
    return nil unless student_race_data

    new(
      student_race_data['race_id'],
      student_race_data['student_id'],
      student_race_data['lane'],
      student_race_data['position']
    )
  end
end
