require 'rails_helper'

RSpec.describe RacesController, type: :controller do
  let(:student1) { Student.new("Student 1").save }
  let(:student2) { Student.new("Student 2").save }
  let(:race) { Race.new("Race 1").save }

  before do
    @session = {}
    allow(controller).to receive(:session).and_return(@session)

    SessionInfo.session = @session
  end

  describe 'GET #index' do
    it 'displays all the races' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    it 'renders the new form' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid student_ids' do
      it 'creates a new race and student_races, then redirects to races_path' do
        post :create, params: { race_name: 'New Race', student_ids: [student1.id, student2.id] }

        expect(Race.all.size).to eq(1)
        expect(StudentRace.all.size).to eq(2)
        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('race.created'))
      end
    end

    context 'with less than 2 students' do
      it 'redirects to new_race_path with an alert' do
        post :create, params: { race_name: 'New Race', student_ids: [student1.id] }

        expect(response).to redirect_to(new_race_path)
        expect(flash[:alert]).to eq(I18n.t('race.atleast_two'))
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit form' do
      get :edit, params: { id: race.id }
      expect(response).to have_http_status(:ok)
    end

    it 'redirects to races_path if race not found' do
      get :edit, params: { id: 999 }
      expect(response).to redirect_to(races_path)
      expect(flash[:alert]).to eq(I18n.t('race.not_found'))
    end
  end

  describe 'PATCH #update' do
    let!(:student_race1) { StudentRace.new(race.id, student1.id, 1).save }
    let!(:student_race2) { StudentRace.new(race.id, student2.id, 2).save }

    context 'with valid positions' do
      it 'updates student positions and redirects to races_path' do
        patch :update, params: { id: race.id, student_ids: [student1.id, student2.id], positions: [2, 1] }

        updated_race1 = StudentRace.find_by_id(student1.id, race.id)
        updated_race2 = StudentRace.find_by_id(student2.id, race.id)

        expect(updated_race1.position).to eq('2')
        expect(updated_race2.position).to eq('1')
        expect(response).to redirect_to(races_path)
        expect(flash[:notice]).to eq(I18n.t('race.position_update'))
      end
    end

    context 'when positions are missing' do
      it 'redirects to edit_race_path with an alert' do
        patch :update, params: { id: race.id, student_ids: [student1.id, student2.id], positions: [2] }

        expect(response).to redirect_to(edit_race_path(race.id))
        expect(flash[:alert]).to eq(I18n.t('race.position_required'))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the race and redirects to races_path' do
      delete :destroy, params: { id: race.id }
      expect(Race.find_by_id(id: race.id)).to be_nil
      expect(response).to redirect_to(races_path)
    end
  end

  describe 'POST #reset' do
    it 'clears session data and redirects to new_race_path' do
      post :reset
      expect(session[:races]).to be_nil
      expect(session[:student_races]).to be_nil
      expect(session[:students]).to be_nil
      expect(response).to redirect_to(new_race_path)
    end
  end
end
