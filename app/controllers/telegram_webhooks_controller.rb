# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  before_action :current_tg_user

  def add!(*links)
    return respond_with :message, text: 'Команда только для админа' unless @current_tg_user.admin?
    return respond_with :message, text: 'Уже есть активный раунд' if Round.active.find_by_chat_id(chat['id']).present?

    result = Round::Creator.new(links, chat['id']).create_round_with_matches
    respond_with :message, text: result.message
  end

  def predict!(*predictions)
    round = Round.active.find_by_chat_id(chat['id'])
    return respond_with :message, text: 'Матчи не добавлены' if round.nil?
    return respond_with :message, text: 'Прогнозы не принимаются. Матчи стартовали' if round.matches_started?
    return respond_with :message, text: 'Прогнозы не на все матчи' unless round.matches.count == predictions.count

    result = Prediction::Creator.new(round, @current_tg_user, predictions).create_user_predictions
    respond_with :message, text: result.message
  end

  private

  def current_tg_user
    @current_tg_user ||= User.find_by_telegram_id(from['id'])
    @current_tg_user ||= User.create(telegram_id: from['id'], name: from['first_name'])
  end
end
