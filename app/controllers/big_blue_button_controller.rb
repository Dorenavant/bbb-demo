class BigBlueButtonController < ApplicationController
  def init
    require "bigbluebutton_api"

    url = "http://10.107.111.235//bigbluebutton/api"
    secret = "6d9e7029cd2393a7a9abb52fedc0e6bb"
    version = "0.9"
    @api = BigBlueButton::BigBlueButtonApi.new(url, secret, version.to_s, true)

    # Create demo meeting to join
    @name = "Demo Meeting"
    @id = "testID"
    @options = {:moderatorPW => "asdf",
                :attendeePW => "fdsa",
                :welcome => "Welcome to the Demo Meeting",
                :logoutURL => "https://google.ca",
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

      # TODO: Add error message if password is not moderator or attendee password
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
end
