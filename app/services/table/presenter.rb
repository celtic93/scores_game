# frozen_string_literal: true

class Table::Presenter
  CORRECT_SCORE_POINTS = 4
  HANDICAP_POINTS = 2
  MATCH_RESULT_POINTS = 1

  def calculate_points(round)
    result = Result.new
    messages_array = ['Турнирная таблица:']
    table_hash = {}
    round.users.each do |user|
      table_hash[user.name] = 0
    end

    round.matches.ordered_by_id.each do |match|
      next if match.result.nil? || match.status.nil?

      match.predictions.each do |prediction|
        match_score_array = match.result.split(' - ').map(&:to_i)
        prediction_array = prediction.score.split('-').map(&:to_i)

        match_handicap = match_score_array[0] - match_score_array[1]
        prediction_handicap = prediction_array[0] - prediction_array[1]

        if match_score_array == prediction_array
          table_hash[prediction.user.name] += CORRECT_SCORE_POINTS
        elsif match_handicap == prediction_handicap
          table_hash[prediction.user.name] += HANDICAP_POINTS
        elsif (match_handicap * prediction_handicap).positive?
          table_hash[prediction.user.name] += MATCH_RESULT_POINTS
        end
      end
    end

    table_hash.each do |name, points|
      messages_array.push("#{name} #{points}")
    end
    result.message = messages_array.join("\n")
    result
  end

  class Result
    attr_accessor :message
  end
end
