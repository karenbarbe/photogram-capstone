class UsersController < ApplicationController
  def index
    @users = User.all
    render({ :template => "user_templates/index" })
  end
end
