class Race
  include SessionInfo
  extend SessionInfo
  attr_accessor :id, :name

  def initialize(name = nil, id = nil)
    @name = name
    @id = id
  end

  def save
    session[:races] ||= []
    self.id ||= next_id
    session[:races].push({ 'id' => id, 'name' => name })
    self
  end

  def destroy
    session[:student_races]&.reject! { |student_race_data| student_race_data['race_id'] == id }
    session[:races]&.reject! { |race_data| race_data['id'] == id }
  end

  def self.all
    races = self.session[:races] || []
    races.map { |race_data| new(race_data['name'], race_data['id']) }
  end

  def self.find_by_id(id)
    race_data = self.session[:races]&.find { |r| r['id'] == id }
    return nil unless race_data

    new(race_data['name'], race_data['id'])
  end

  def students_list
    student_races = session[:student_races]
    student_races.select { |sr| sr['race_id'] == id }.map do |student_race_data|
      Student.find_by_id(student_race_data['student_id'])
    end.compact
  end

  def student_races_list
    student_races = session[:student_races]
    student_races.select { |sr| sr['race_id'] == id }.map do |student_race_data|
      StudentRace.new(
        student_race_data['race_id'],
        student_race_data['student_id'],
        student_race_data['lane'],
        student_race_data['position']
      )
    end
  end

  private

  def next_id
    races = session[:races] || []
    races.empty? ? 1 : races.map { |r| r['id'] }.max + 1
  end
end
