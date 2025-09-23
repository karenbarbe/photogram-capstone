class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [ :index ] })

  def index
    public_users = User.where({ :private => false })
    matching_photos = Photo.where({ :owner_id => public_users })

    @public_photos = matching_photos.includes([ :owner ]).order({ :created_at => :desc })

    render({ :template => "photo_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => the_id })

    @the_photo = matching_photos.at(0)

     @like_by_current_user = Like.where({ :fan_id => current_user.id }).first

    render({ :template => "photo_templates/show" })
  end

  def create
    the_photo = Photo.new
    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = current_user.id

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos", { :notice => "Photo created successfully." })
    else
      redirect_to("/photos", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.caption = params.fetch("query_caption")
    the_photo.image = params.fetch("query_image")
    the_photo.owner_id = current_user.id

    if the_photo.valid?
      the_photo.save
      redirect_to("/photos/#{the_photo.id}", { :notice => "Photo updated successfully." } )
    else
      redirect_to("/photos/#{the_photo.id}", { :alert => the_photo.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_photo = Photo.where({ :id => the_id }).at(0)

    the_photo.destroy

    redirect_to("/photos", { :notice => "Photo deleted successfully." } )
  end
end
