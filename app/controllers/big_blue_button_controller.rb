class BigBlueButtonController < ApplicationController
  def init
    require "bigbluebutton_api"

    url = (ENV['BIGBLUEBUTTON_ENDPOINT'] || 'http://test-install.blindsidenetworks.com/bigbluebutton/') + 'api'
    secret = ENV['BIGBLUEBUTTON_SECRET'] || '8cd8ef52e8e101574e400365b55e11a6'
    version = "0.9"
    @api = BigBlueButton::BigBlueButtonApi.new(url, secret, version.to_s, true)

    # Create demo meeting to join
    @name = "Demo Meeting"
    @id = "testID"
    @options = {:moderatorPW => ENV['DEMO_MP'] || 'mp',
                :attendeePW => ENV['DEMO_AP'] || 'ap',
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
