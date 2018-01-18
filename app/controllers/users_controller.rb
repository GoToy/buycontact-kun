class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    end

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit


  end

  # POST /users
  # POST /users.json
  def create
     client = User.client
    body = request.body.read
    events = client.parse_events_from(body)
    events.each { |event|
     user = User.find_or_create_by(line_id: event['source']['userId'])
     case event
      
      when Line::Bot::Event::Postback
       parsed_data = CGI::parse(event["postback"]["data"])
       case parsed_data['action'][0]
       when /change_contact_num/
         before_update_num = user.remain || 0
         user.update(remain: before_update_num + parsed_data['num'][0].to_i)
          if user.reload.remain == 7
            message = {
              type: 'text',
              text: "残数#{before_update_num}個に対し、#{parsed_message.to_i}個足して、#{user.reload.remain}個になりました\nhttps://www.lensmode.com/auth/login/redirectUrl/%252Fmypage%252Findex%252F/"
            }
          else 
            message = {
              type: 'text',
              text: "残数#{before_update_num}個に対し、#{parsed_message.to_i}個足して、#{user.reload.remain}個になりました"
           } 
          end
             client.reply_message(event['replyToken'],message)
       end 
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {}

          parsed_message = event.message['text'].match(/[0-9]+|\-[0-9]+/).to_s

          if parsed_message.present?
            before_update_num = user.remain || 0
            user.update(remain: before_update_num + parsed_message.to_i)
          if user.reload.remain == 7
            message = {
              type: 'text',
              text: "残数#{before_update_num}個に対し、#{parsed_message.to_i}個足して、#{user.reload.remain}個になりました\nhttps://www.lensmode.com/auth/login/redirectUrl/%252Fmypage%252Findex%252F/"
            }
          else 
            message = {
              type: 'text',
              text: "残数#{before_update_num}個に対し、#{parsed_message.to_i}個足して、#{user.reload.remain}個になりました"
           } 
          end
          else
            message = {
              type: 'text',
              text: event.message['text']
           }
          end

          client.reply_message(event['replyToken'], message)
        end
     end 
    }
  head :ok


  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
 
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :remain)
    end
end
