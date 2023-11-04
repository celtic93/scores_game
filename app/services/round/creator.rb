# frozen_string_literal: true

class Round::Creator
  def initialize(links, chat_id)
    @result = Result.new
    @messages_array = []
    @links = links
    @chat_id = chat_id
  end

  def create_round_with_matches
    return result if links_empty?

    create_round
    create_matches
    make_matches_list_message

    result
  end

  private

  attr_accessor :result, :messages_array, :round, :links, :chat_id

  def links_empty?
    result.message = 'Ссылки отстутсвуют' if links.empty?
    links.empty?
  end

  def create_round
    @round = Round.create(chat_id: chat_id, active: true)
  end

  def create_matches
    links.each do |match|
      date_time, link_path = match.split('_')
      date_time = DateTime.parse("#{date_time} #{Time.zone}")
      parser_result = Match::Parser.new.extract_link(link_path)

      Match.create(
        home_team: parser_result.home_team, guest_team: parser_result.guest_team, result: parser_result.result,
        status: parser_result.status, date_time: date_time, link_path: link_path, round_id: round.id
      )
    end
  end

  def make_matches_list_message
    messages_array.push('Добавлены матчи:')
    round.matches.ordered_by_id.each do |match|
      messages_array.push(
        "#{match.date_time.strftime('%d-%m-%Y %H:%M')} #{match.home_team} - #{match.guest_team}"
      )
    end
    result.message = messages_array.join("\n")
  end

  class Result
    attr_accessor :message
  end
end
