class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :username => :asc })
    
    render({ :template => "user_templates/index"})
  end

  def show
    url_username = params.fetch("path_username")

    matching_usernames = User.where({ :username => url_username })

    @the_user = matching_usernames.at(0)

      render({ :template => "user_templates/show"})
  end

  def create
    new_user = User.new(username: params[:input_username])
    if new_user.save
      redirect_to "/users/#{new_user.username}"
    else
      redirect_to "/users", alert: "Error creating user."
    end
  end

  def update
    # Fetch the original username from the URL path
    url_username = params.fetch("path_username")
    the_user = User.find_by(username: url_username)

    # Handle the case where the user isn't found
    if the_user.nil?
      redirect_to "/users", alert: "User not found."
      return
    end

    # Update the username from the form input
    new_username = params.fetch("input_username")
    the_user.username = new_username

    # Save changes and always redirect to the new URL
    if the_user.save
      redirect_to "/users/#{the_user.username}", notice: "User updated successfully."
    else
      redirect_to "/users/#{url_username}", alert: "Error updating user."
    end
  end
end
