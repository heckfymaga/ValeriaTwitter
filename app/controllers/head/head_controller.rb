class Head::HeadController < ApplicationController
  before_action :authenticate_user!
  before_action :check_head
  layout 'head'
  private

  def check_head
    if !current_user.head?
      redirect_to root_path, alert: "У вас нет прав доступа"
    end
  end
end