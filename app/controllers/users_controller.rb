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
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {}

          parsed_message = event.message['text'].gsub(/\D/, '')

          if parsed_message.present?
            before_addition_num = user.remain
            user.update(remain: user.remain + parsed_message.to_i)

            message = {
              type: 'text',
              text: "残数#{before_addition_num}個に対し、#{parsed_message.to_i}個足して、#{user.reload.remain}個になりました"
            }
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
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
