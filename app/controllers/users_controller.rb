class UsersController < ApplicationController
  
rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def create
    new_user = User.create!(user_params)
    session[:user_id] = new_user.id
    render json: new_user, status: :created
  end

  def show
    this_user = User.find_by(id: session[:user_id])
    if this_user
      render json: this_user, status: :created
    else
      render json: {error: "User is not logged in, please return to the login page."}, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def render_unprocessable_entity_response(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

end
