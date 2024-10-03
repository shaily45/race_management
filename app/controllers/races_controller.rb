class RacesController < ApplicationController
  before_action :seeding_data_if_not_present?
  before_action :find_race, only: %i[edit update destroy]

  def index
    @races = Race.all
  end

  def new
    @students = Student.all
  end

  def create
    student_ids = params[:student_ids]

    if student_ids.size < 2
      return redirect_to new_race_path, alert: I18n.t('race.atleast_two')
    end

    race = Race.new(params[:race_name]).tap { |r| r.save }

    student_ids.each_with_index do |student_id, index|
      StudentRace.new(race.id, student_id.to_i, index + 1).tap { |sr| sr.save }
    end

    redirect_to races_path, notice: I18n.t('race.created')
  end

  def edit; end

  def update
    student_ids = params[:student_ids]
    positions = params[:positions]
    return redirect_to edit_race_path(@race.id), alert: I18n.t('race.position_required') unless student_ids.size == positions.size

    race_service = RaceService.new(@race)
    unless race_service.update_positions(student_ids, positions)
      return redirect_to edit_race_path(@race.id), alert: race_service.error
    end

    redirect_to races_path, notice: I18n.t('race.position_update')
  end

  def destroy
    @race.destroy
    redirect_to races_path
  end

  def reset
    session.delete(:races)
    session.delete(:student_races)
    session.delete(:students)
    redirect_to new_race_path
  end

  private

  def find_race
    @race = Race.find_by_id(params[:id].to_i)
    if @race.nil?
      return redirect_to races_path, alert: I18n.t('race.not_found')
    end
  end
end
