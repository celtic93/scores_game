# frozen_string_literal: true

Rails.application.routes.draw do
  telegram_webhook TelegramWebhooksController

  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'
end
