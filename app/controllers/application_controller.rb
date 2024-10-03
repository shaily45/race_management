class ApplicationController < ActionController::Base
  before_action :set_session
  around_action :handle_exceptions

  def seeding_data_if_not_present?
    if session[:students].nil?
      (1..10).each do
        student = Student.new(Faker::Name.name)
        student.save
      end
    end
  end

  def set_session
    SessionInfo.session = session
  end

  def handle_exceptions
    yield
  rescue StandardError => e
    redirect_to root_path, notice: e.message
  end
end
