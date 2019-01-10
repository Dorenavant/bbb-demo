class BigBlueButtonController < ApplicationController
  def init
    require "bigbluebutton_api"

    @api = BigBlueButton::BigBlueButtonApi.new(
      Rails.configuration.bigbluebutton_endpoint,
      Rails.configuration.bigbluebutton_secret,
      Rails.configuration.bigbluebutton_version,
      true
    )

    # Create demo meeting to join
    @name = "Demo Meeting"
    @id = "testID"
    @options = {:moderatorPW => Rails.configuration.demo_moderator_pw,
                :attendeePW => Rails.configuration.demo_attendee_pw,
                :welcome => "Welcome to the Demo Meeting",
                :logoutURL => "https://google.ca",
                :record => true,
                :maxParticipants => 25}

    unless @api.is_meeting_running?(@id) # Check if meeting is running
      @api.create_meeting(@name, @id, @options)
    end
  end

  def login
  end

  def join
    @join_name = params[:big_blue_button][:name]
    join_password = params[:big_blue_button][:password]

    unless @join_name == "" # Cannot join with empty name
      init

      if join_password == @options[:moderatorPW]
        meeting_url = @api.join_meeting_url(@id, @join_name, @options[:moderatorPW])
        redirect_to meeting_url
      elsif join_password == @options[:attendeePW]
        meeting_url = @api.join_meeting_url(@id, @join_name, @options[:attendeePW])
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
    init

    # @api.get_meetings()
    recordings = @api.get_recordings({:meetingID => @id})
  end
end
