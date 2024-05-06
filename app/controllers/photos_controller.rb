class PhotosController < ApplicationController
  def index
    matching_photos = Photo.all

    @list_of_photos = matching_photos.order({ :created_at => :desc })

    render({ :template => "photo_templates/index"})
  end

  def show
    url_id = params.fetch("path_id")

    matching_photos = Photo.where({ :id => url_id })

    @the_photo = matching_photos.at(0)

    @new_comment = Comment.new

    render({ :template => "photo_templates/show" })
  end

  def destroy
    the_id = params.fetch("toast_id")

    matching_photos = Photo.where({ :id => the_id })

    the_photo = matching_photos.at(0)

    the_photo.destroy

    #render({ :template => "photo_templates/destroy" })
    redirect_to("/photos")
  end

  def create
    new_photo = Photo.new(
      image: params[:input_image],
      caption: params[:input_caption],
      owner_id: params[:input_owner_id]
    )

    unless new_photo.valid?
      Rails.logger.debug "Photo validation errors: #{new_photo.errors.full_messages.join(", ")}"
    end

    if new_photo.save
      redirect_to "/photos/#{new_photo.id}", notice: "Photo created successfully."
    else
      redirect_to "/photos", alert: "Error creating photo."
    end
  end

  def update
    the_id = params.fetch("modify_id")
    matching_photos = Photo.where({ :id => the_id })
    the_photo = matching_photos.at(0)
    
    input_image = params.fetch("query_image")
    input_caption = params.fetch("query_caption")

    the_photo.image = input_image
    the_photo.caption = input_caption
    
    the_photo.save

    #render({ :template => "photo_templates/update" })
    redirect_to "/photos/#{the_photo.id}", notice: "Photo created successfully."
  end

  def add_comment
    photo_id = params.fetch("photo_id")
    new_comment = Comment.new
    new_comment.photo_id = photo_id
    new_comment.author_id = params.fetch("input_author_id")
    new_comment.body = params.fetch("input_comment")

    if new_comment.save
      redirect_to "/photos/#{photo_id}", notice: "Comment added successfully."
    else
      redirect_to "/photos/#{photo_id}", alert: "Error adding comment."
    end
  end
end
