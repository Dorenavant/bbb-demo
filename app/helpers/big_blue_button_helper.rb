module BigBlueButtonHelper
  def getRecLength(recPlayback)
    unless recPlayback[:type] == "statistics"
      if recPlayback[:length] == 0
        "< 1 min"
      elsif recPlayback[:length] < 60
        "#{recPlayback[:length]} min"
      else
        "#{(recPlayback[:length] / 60).floor} hrs #{(recPlayback[:length] % 60)} min"
      end
    else
      "NULL"
    end
  end

  def getRecDate(recPlayback)
    require "date"
    recPlayback[:startTime].strftime("%m/%d/%Y")
  end
end
