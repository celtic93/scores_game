# frozen_string_literal: true

class Prediction::Presenter
  def show_predictions(round)
    result = Result.new
    messages_array = []

    round.matches.each do |match|
      match_array = []
      match_array.push(match.date_time.strftime('%d-%m-%Y %H:%M'))
      match_array.push("#{match.home_team} - #{match.guest_team} #{match.result} #{match.status}")
      predictions_array = match.predictions.map { |prediction| "#{prediction.user.name} #{prediction.score}" }
      match_array.push(predictions_array.join(' | '))
      messages_array.push(match_array.join("\n"))
    end

    result.message = messages_array.join("\n\n")
    result
  end

  class Result
    attr_accessor :message
  end
end
