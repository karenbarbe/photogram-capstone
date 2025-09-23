class UsersController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [ :index ] })
  before_action :get_followed_user_ids, only: [ :show, :feed, :discover ]
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
    @own_photos = @matching_user.photos.includes([ :owner ])

    render({ :template => "user_templates/own_photos" })
  end

  def liked_photos
    @liked_photos = @matching_user.liked_photos.includes([ :owner ])

    render({ :template => "user_templates/liked_photos" })
  end

  def feed
   @feed = Photo.where(owner_id: @followed_users_ids).includes([ :owner ]).order(created_at: :desc)

    render({ :template => "user_templates/feed" })
  end

  def discover
    @discover = Photo.joins(:likes)
                  .where(likes: { fan_id: @followed_users_ids })
                  .includes([ :owner ])
                  .distinct
                  .order(created_at: :desc)


    render({ :template => "user_templates/discover" })
  end

  private

  def get_followed_user_ids
    @followed_users_ids =FollowRequest.where(status: "accepted", sender_id: current_user.id)
              .pluck(:recipient_id)
  end

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
