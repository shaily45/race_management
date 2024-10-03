require 'rails_helper'

RSpec.describe Race do
  let(:name) { 'User1' }
  let(:id) { 1 }

  before(:each) do
    SessionInfo.session = {
      races: [],
      student_races: [],
      students: []
    }
  end

  describe '#new' do
    it 'should initialize the race object' do
      race = Race.new(name, id)
      expect(race.id).to eq(id)
      expect(race.name).to eq(name)
    end
  end

  describe '#save' do
    it 'should save the race' do
      race = Race.new(name, id).tap { |r| r.save }
      expect(Race.all.size).to eq(1)
    end
  end

  describe '#destroy' do
    it 'should save and destroy race' do
      race = Race.new(name, id).tap { |r| r.save }
      race.destroy
      expect(Race.all.size).to eq(0)
    end
  end

  describe '#all' do
    it 'should return all the races object' do
      (0...5).each do |i|
        race = Race.new(i.to_s, i).tap { |r| r.save }

        races = Race.all
        expect(races[i].id).to eq(race.id)
        expect(races[i].name).to eq(race.name)
      end

      expect(Race.all.size).to eq(5)
    end
  end

  describe '#find_by_id' do
    it 'should find the race and return' do
      (0...5).each do |i|
        race = Race.new(i.to_s, i).tap { |r| r.save }
      end

      race = Race.find_by_id(3)

      expect(race).to be_an_instance_of(Race)
      expect(race.id).to eq(3)
      expect(race.name).to eq('3')
    end
  end

  describe '#students_list' do
    it 'should return all the students of the race' do
      race = Race.new('Race1', 1).tap { |r| r.save }
      (0...5).each do |i|
        student = Student.new("student-#{i}", i).tap { |s| s.save }
        StudentRace.new(race.id, student.id, i).tap { |sr| sr.save }

        students = race.students_list
        expect(students[i].id).to eq(student.id)
      end

      expect(StudentRace.all.size).to eq(5)
    end
  end

  describe '#student_races_list' do
    it 'should return all the student_races of the race' do
      race = Race.new('Race1', 1).tap { |r| r.save }
      (0...5).each do |i|
        student = Student.new("student-#{i}", i).tap { |s| s.save }
        student_race = StudentRace.new(race.id, student.id, i).tap { |sr| sr.save }

        student_races = race.student_races_list
        expect(student_races[i].student_id).to eq(student.id)
        expect(student_races[i].race_id).to eq(race.id)
        expect(student_races[i].lane).to eq(student_race.lane)
        expect(student_races[i].position).to eq(student_race.position)
      end

      expect(StudentRace.all.size).to eq(5)
    end
  end
end
