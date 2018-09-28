class Admin::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user
  layout 'admin'
  private

  def check_user
    if current_user.normal?
      redirect_to root_path, alert: "У вас нет прав доступа"
    end
  end
end