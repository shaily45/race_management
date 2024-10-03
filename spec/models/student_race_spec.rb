require 'rails_helper'

RSpec.describe StudentRace do
  before(:each) do
    SessionInfo.session = {
      races: [],
      student_races: [],
      students: []
    }

    @student = Student.new('User1', 1).tap(&:save)
    @race = Race.new('Race1', 1).tap(&:save)
  end

  describe '#new' do
    it 'initializes the student_race object' do
      student_race = StudentRace.new(@race.id, @student.id, 1)
      expect(student_race.race_id).to eq(@race.id)
      expect(student_race.student_id).to eq(@student.id)
    end
  end

  describe '#save' do
    it 'saves the student_race' do
      student_race = StudentRace.new(@race.id, @student.id, 1).tap(&:save)
      expect(StudentRace.all.size).to eq(1)
    end
  end

  describe '#destroy' do
    it 'saves and destroys the student_race' do
      student_race = StudentRace.new(@race.id, @student.id, 1).tap(&:save)
      student_race.destroy
      expect(StudentRace.all.size).to eq(0)
    end
  end

  describe '#all' do
    it 'returns all student_race objects' do
      (0...5).each do |i|
        student = Student.new("student-#{i}", i).tap(&:save)
        race = Race.new("race-#{i}", i).tap(&:save)

        student_race = StudentRace.new(race.id, student.id, i).tap(&:save)

        student_races = StudentRace.all
        expect(student_races[i].student_id).to eq(student.id)
        expect(student_races[i].race_id).to eq(race.id)
        expect(student_races[i].lane).to eq(student_race.lane)
        expect(student_races[i].position).to eq(student_race.position)
      end

      expect(StudentRace.all.size).to eq(5)
    end
  end

  describe '#find_by_id' do
    it 'finds and returns the student_race' do
      (0...5).each do |i|
        student = Student.new("student-#{i}", i).tap(&:save)
        race = Race.new("race-#{i}", i).tap(&:save)

        student_race = StudentRace.new(race.id, student.id, i).tap(&:save)
      end

      student_race = StudentRace.find_by_id(@student.id, @race.id)

      expect(student_race).to be_an_instance_of(StudentRace)
      expect(student_race.student_id).to eq(@student.id)
      expect(student_race.race_id).to eq(@race.id)
    end
  end

  describe '#race and #student' do
    it 'returns the associated race and student' do
      student_race = StudentRace.new(@race.id, @student.id, 1).tap(&:save)

      expect(student_race.race.id).to eq(@race.id)
      expect(student_race.student.id).to eq(@student.id)
    end
  end
end
