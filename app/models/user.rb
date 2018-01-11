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
      "text": "残数#{self.remain}個です。\nコンタクトをつけましたか?",
      "actions": [
          {
            "type": "postback",
            "label": "はい",
            "data": "action=change_contact_num&num=-1",
            "text": "はい"
          },
          {
            "type": "postback",
            "label": "いいえ",
            "data": "action=change_contact_num&num=0",
            "text": "いいえ"
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
