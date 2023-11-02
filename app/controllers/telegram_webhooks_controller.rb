# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  before_action :current_tg_user

  def message(*)
    respond_with :message, text: @current_tg_user.name
  end

  private

  def current_tg_user
    telegram_id = from['id'].to_i
    @current_tg_user ||= User.find_by_telegram_id(telegram_id)
    @current_tg_user ||= User.create(telegram_id: telegram_id, name: "#{from['first_name']} #{from['last_name']}".strip)
  end
end
