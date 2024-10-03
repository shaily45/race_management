class Student
  include SessionInfo
  extend SessionInfo
  attr_accessor :id, :name

  def initialize(name, id = nil)
    @name = name
    @id = id
  end

  def save
    session[:students] ||= []
    self.id ||= next_id
    session[:students].push({ 'id' => id, 'name' => name })
    self
  end

  def destroy
    session[:students]&.reject! { |student_data| student_data['id'] == id }
  end

  def self.all
    (session[:students] || []).map do |student_data|
      new(student_data['name'], student_data['id'].to_i)
    end
  end

  def self.find_by_id(id)
    student_data = session[:students]&.find { |s| s['id'] == id }
    return nil unless student_data

    new(student_data['name'], student_data['id'].to_i)
  end

  private

  def next_id
    students = session[:students] || []
    students.empty? ? 1 : students.map { |s| s['id'].to_i }.max + 1
  end
end
