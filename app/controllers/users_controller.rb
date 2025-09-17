class UsersController < ApplicationController
  def index
    @users = User.all.order(:username)
    render({ :template => "user_templates/index" })
  end

  def show
    the_username = params.fetch("path_username")

    @matching_user = User.where({ :username => the_username }).first

    render({ :template => "user_templates/show" })
  end
end
