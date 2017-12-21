class User < ApplicationRecord
require 'line/bot'

  def self.client
    client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def morning_contact
    message = {

  "type": "template",
  "altText": "this is a confirm template",
  "template": {
      "type": "confirm",
      "text": "残数#{user.remain}個です。\nコンタクトをつけましたか?",
      "actions": [
          {
            "type": "uri",
            "label": "はい",
            "uri": "https://buycontact-kun.herokuapp.com/users/#{user.id}/update_contacts"
          },
          {
            "type": "uri",
            "label": "いいえ",
            "uri": "https://buycontact-kun.herokuapp.com/users/#{user.id}/show_contacts"
          }
       ]
     }
}
client = User.client
response = client.push_message(self.line_id, message)
p response

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
