# frozen_string_literal: true

class Match::Monitor
  MATCH_ENDED_STATUS = 'Match ended'

  def initialize(round, match)
    @match = match
    @messages_array = []
    @result = Result.new
    @round = round
    @show_table = false
  end

  def check_score
    return result if match_is_not_in_progress?

    parse_match_score
    check_score_and_status_changing if match_has_different_predictions?
    update_match
    make_message if match_has_different_predictions?

    result
  end

  private

  attr_accessor :match, :messages_array, :result, :parser_result, :round, :show_table

  def match_is_not_in_progress?
    Time.zone.now < match.date_time || match.status == MATCH_ENDED_STATUS
  end

  def match_has_different_predictions?
    @match_has_different_predictions ||= match.different_predictions?
  end

  def parse_match_score
    @parser_result = Match::Parser.new.extract_link(match.link_path)
  end

  def check_score_and_status_changing
    if match.status.nil? && parser_result.status.present? && parser_result.status != MATCH_ENDED_STATUS
      messages_array.push('Матч начался')
    end
    if match.result.present? && match.result != parser_result.result
      messages_array.push('Изменение в счете')
      @show_table = true
    end
    if parser_result.status == MATCH_ENDED_STATUS
      messages_array.push('Матч закончился')
      @show_table = true
    end
  end

  def update_match
    match.update(result: parser_result.result, status: parser_result.status)
  end

  def make_message
    if messages_array.any?
      messages_array.push("#{match.home_team} - #{match.guest_team}")
      messages_array.push("#{match.result} (#{match.status})")
    end

    if show_table
      table_result = Table::Presenter.new.calculate_points(round)
      messages_array.push(table_result.message)
    end

    result.message = messages_array.join("\n")
  end

  class Result
    attr_accessor :message
  end
end
