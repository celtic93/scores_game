# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  before_action :current_tg_user

  def add!(*links)
    return respond_with :message, text: 'Команда только для админа' unless @current_tg_user.admin?
    return respond_with :message, text: 'Уже есть активный раунд' if Round.active.find_by_chat_id(chat['id']).present?

    result = Round::Creator.new(links, chat['id']).create_round_with_matches
    respond_with :message, text: result.message
  end

  private

  def current_tg_user
    telegram_id = from['id'].to_i
    @current_tg_user ||= User.find_by_telegram_id(telegram_id)
    @current_tg_user ||= User.create(telegram_id: telegram_id, name: from['first_name'])
  end
end
