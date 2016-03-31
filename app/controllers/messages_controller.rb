class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    @message.user = current_user

    if @message.save
      flash[:success] = 'sent message successfully.'
      redirect_to home_index_path
    else
      flash[:error] = 'sent message unsuccessfully.'
      redirect_to home_index_path
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :user_id)
  end
end
