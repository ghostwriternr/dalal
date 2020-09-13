require 'sidekiq'
require 'sidekiq/web'

class BaseWorker
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform(name, count)
  end
end