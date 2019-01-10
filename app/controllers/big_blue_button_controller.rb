class BigBlueButtonController < ApplicationController
  before_action :initAPI

  def login
    createMeeting
  end

  def join
    @join_name = params[:big_blue_button][:name] # Instance variable so view can repopulate
    join_password = params[:big_blue_button][:password]

    unless @join_name == "" # Cannot join with empty name
      if join_password == session[:moderatorPW]
        meeting_url = @api.join_meeting_url(session[:id],
                                            @join_name,
                                            session[:moderatorPW])
        redirect_to meeting_url
      elsif join_password == session[:attendeePW]
        meeting_url = @api.join_meeting_url(session[:id],
                                            @join_name,
                                            session[:attendeePW])
        redirect_to meeting_url
      else
        @error_state = true
      end
    else
      puts "DEBUG: No name was entered."
    end
  rescue Exception => ex
    puts "Failed with error #{ex.message}"
    puts ex.backtrace
  end

  def get_recordings
    @api.join_meeting_url(session[:id],
                          @join_name,
                          session[:attendeePW])
    recordings = @api.get_recordings({:meetingID => session[:id]})
    # render plain: recordings
  end

  private

  def initAPI
    require "bigbluebutton_api"

    @api = BigBlueButton::BigBlueButtonApi.new(
      Rails.configuration.bigbluebutton_endpoint,
      Rails.configuration.bigbluebutton_secret,
      Rails.configuration.bigbluebutton_version,
      true
    )
  end

  def createMeeting
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

    unless @api.is_meeting_running?(session[:id]) # Check if meeting is running
      @api.create_meeting(session[:name],
                          session[:id],
                          options)
    end
  end
end
