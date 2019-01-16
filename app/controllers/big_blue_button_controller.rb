class BigBlueButtonController < ApplicationController
  before_action :initAPI
  after_action :get_recordings

  def login
    create_meeting
  end

  def join
    @error_msgs = {"empty_name" => "Cannot join with empty name",
                   "incorrect_pw" => "Incorrect password"}

    @join_name = params[:big_blue_button][:name] # Instance variable so view can repopulate
    join_password = params[:big_blue_button][:password]

    if /[a-zA-Z0-9]/.match(@join_name) # Cannot join with empty name
      if join_password == session[:moderatorPW]
        create_meeting
        silently do
          meeting_url = @api.join_meeting_url(session[:id],
                                              @join_name,
                                              session[:moderatorPW])
        end
        redirect_to meeting_url
      elsif join_password == session[:attendeePW]
        create_meeting
        silently do
          meeting_url = @api.join_meeting_url(session[:id],
                                              @join_name,
                                              session[:attendeePW])
        end
        redirect_to meeting_url
      else
        @error_state = true
        @error_msg = @error_msgs["incorrect_pw"]
      end
    else
      @error_state = true
      @error_msg = @error_msgs["empty_name"]
    end
  rescue Exception => ex
    puts "Failed with error #{ex.message}"
    puts ex.backtrace
  end

  def get_recordings
    silently do
      @recording_data = @api.get_recordings({:meetingID => session[:id]})[:recordings]
    end
  end

  def delete_recording
    silently do
      @api.delete_recordings(params[:rec_id])
    end
    sleep(5)
    get_recordings
  end

  private # Private helpers

  def initAPI
    require "bigbluebutton_api"

    @api = BigBlueButton::BigBlueButtonApi.new(
      Rails.configuration.bigbluebutton_endpoint,
      Rails.configuration.bigbluebutton_secret,
      Rails.configuration.bigbluebutton_version,
      true
    )
  end

  def create_meeting
    # Create demo meeting to join
    session[:name] = "Demo Meeting"
    session[:id] = "testID"
    session[:moderatorPW] = Rails.configuration.demo_moderator_pw
    session[:attendeePW] = Rails.configuration.demo_moderator_pw
    options = {:moderatorPW => session[:moderatorPW],
               :attendeePW => session[:attendeePW],
               :welcome => "Welcome to the Demo Meeting",
               :logoutURL => "https://google.ca",
               :record => true,
               :maxParticipants => 25}

    silently do
      unless @api.is_meeting_running?("session[:id]") # Check if meeting is running
        @api.create_meeting(session[:name],
                            session[:id],
                            options)
      end
    end
  end

  def silently
    begin
      orig_stderr = $stderr.clone
      orig_stdout = $stdout.clone
      $stderr.reopen File.new("/dev/null", "w")
      $stdout.reopen File.new("/dev/null", "w")
      retval = yield
    rescue Exception => e
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
      raise e
    ensure
      $stdout.reopen orig_stdout
      $stderr.reopen orig_stderr
    end
    retval
  end
end
