class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [ :index ] })
  before_action :find_matching_user, only: [ :show, :own_photos, :liked_photos, :feed, :discover ]

  def index
    @users = User.all.order(:username)
    render({ :template => "user_templates/index" })
  end

  def show
    @pending_requests = @matching_user.received_follow_requests.where({ :status => "pending" })
    if @matching_user.private? && !user_can_view_profile?(@matching_user)
      redirect_to("/users", { :alert => "You're not authorized for that." })
    else
      render({ :template => "user_templates/show" })
    end
  end

  def own_photos
    @own_photos = @matching_user.photos

    render({ :template => "user_templates/own_photos" })
  end

  def liked_photos
    @liked_photos = @matching_user.liked_photos

    render({ :template => "user_templates/liked_photos" })
  end

  def feed
    @feed = @matching_user.feed_photos.order(created_at: :desc)

    render({ :template => "user_templates/feed" })
  end

  def discover
    followed_user_ids = @matching_user.followed_users.pluck(:id)
    discoverable_users = User.where.not(id: followed_user_ids)
                          .where.not(id: @matching_user.id)
                          .where(private: false)
    @discover = Photo.where(owner_id: discoverable_users.pluck(:id))
                    .order(created_at: :desc)

    render({ :template => "user_templates/discover" })
  end

  private

  def find_matching_user
    the_username = params.fetch("path_username")
    @matching_user = User.where({ :username => the_username }).first
  end

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
