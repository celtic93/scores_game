class LiveResults
  include Sidekiq::Job

  def perform
    Round.active.each do |round|
      round.matches.ordered_by_id.each do |match|
        result = Match::Monitor.new(round, round.matches.last).check_score
        Telegram.bot.send_message(chat_id: round.chat_id, text: result.message) if result.message.present?
      end
    end
  end
end
