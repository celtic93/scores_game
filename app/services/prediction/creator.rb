# frozen_string_literal: true

class Prediction::Creator
  def initialize(round, user, predictions)
    @result = Result.new
    @round = round
    @user = user
    @predictions = predictions
  end

  def create_user_predictions
    create_predictions
    make_predictions_list_message

    result
  end

  private

  attr_accessor :result, :round, :user, :predictions

  def create_predictions
    predictions.each do |prediction|
      index, score = prediction.split('.')
      corrected_index = index.to_i - 1

      Prediction.create(user: user, match: round.matches[corrected_index], score: score)
    end
  end

  def make_predictions_list_message
    messages_array = ["Текущие прогнозы игрока #{user.name}"]
    user.predictions.for_round(round.id).each_with_index do |prediction, i|
      messages_array.push(
        "#{i + 1}. #{prediction.match.home_team} - #{prediction.match.guest_team} #{prediction.score}"
      )
    end

    result.message = messages_array.join("\n")
  end

  class Result
    attr_accessor :message
  end
end
