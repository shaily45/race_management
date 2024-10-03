require 'rails_helper'

RSpec.describe Student do
  let(:name) { 'User1' }
  let(:id) { 1 }

  before(:each) do
    Thread.current[:session] = { students: [] }
  end

  after(:each) do
    Thread.current[:session] = nil
  end

  describe '#new' do
    it 'initializes the student object' do
      student = Student.new(name, id)
      expect(student.id).to eq(id)
      expect(student.name).to eq(name)
    end
  end

  describe '#save' do
    it 'saves the student' do
      student = Student.new(name, id)
      student.save
      expect(Student.all.size).to eq(1)
    end
  end

  describe '#destroy' do
    it 'saves and destroys the student' do
      student = Student.new(name, id)
      student.save
      expect(Student.all.size).to eq(1)

      student.destroy
      expect(Student.all.size).to eq(0)
    end
  end

  describe '.all' do
    it 'returns all the student objects' do
      (0...5).each do |i|
        student = Student.new(i.to_s, i)
        student.save
      end

      students = Student.all
      expect(students.size).to eq(5)

      students.each_with_index do |student, i|
        expect(student.id).to eq(i)
        expect(student.name).to eq(i.to_s)
      end
    end
  end

  describe '.find_by_id' do
    it 'finds the student by id and returns the student object' do
      (0...5).each do |i|
        Student.new(i.to_s, i).save
      end

      student = Student.find_by_id(3)

      expect(student).to be_an_instance_of(Student)
      expect(student.id).to eq(3)
      expect(student.name).to eq('3')
    end
  end
end
