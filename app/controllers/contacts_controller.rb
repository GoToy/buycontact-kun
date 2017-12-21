class ContactsController < ApplicationController
  def update
    user = User.find(params[:id])
    user_remain = user.remain || 0
    message = {}

    if user_remiain > 0
      user.update(remain: user_remain - 1)
      message = {
      }
    else
      message = {
        type: "text",
        text: "コンタクトがありません"
      }
    end

    user.client.push_message(user.line_id, message)
    head :ok
  end

  def show
    user = User.find(params[:id])
    user_remain = user.remain || 0
    message = {
      type: "text",
      text: "残り#{user.remain}個です"
    }
    user.client.push_message(user.line_id, message)
    head :ok
  end
end
