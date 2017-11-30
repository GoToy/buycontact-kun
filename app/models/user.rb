class User < ApplicationRecord
  def self.client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def instance_method
    p "this is instance_method"
  end


  def self.class_method
    p "this is class method"
  end

  class << self
    def class_method
    end
  end

end
