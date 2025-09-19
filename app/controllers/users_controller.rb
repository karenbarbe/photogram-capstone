class UsersController < ApplicationController
  def index
    @users = User.all.order(:username)
    render({ :template => "user_templates/index" })
  end

  def show
    the_username = params.fetch("path_username")
    @matching_user = User.where({ :username => the_username }).first

    if @matching_user.private? && !user_can_view_profile?(@matching_user)
      redirect_to("/users", { :alert => "You're not authorized for that." })
    else
      render({ :template => "user_templates/show" })
    end
  end

  def own_photos
    the_username = params.fetch("path_username")
    @matching_user = User.where({ :username => the_username }).first
    @own_photos = @matching_user.photos

    render({ :template => "user_templates/own_photos" })
  end

  private

  def user_can_view_profile?(target_user)
    # User can view if:
    # 1. It's their own profile
    # 2. The profile is public
    # 3. They have an accepted follow request
    return true if current_user == target_user
    return true unless target_user.private?

    # Check for accepted follow request
    existing_request = target_user.received_follow_requests.find_by(sender: current_user)
    existing_request&.status == "accepted"
  end
end
