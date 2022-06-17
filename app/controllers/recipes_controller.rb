class RecipesController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    user = User.find_by(id: session[:user_id])
    all_recipes = Recipe.all
    if user 
      render json: all_recipes, status: :created
    else
      render json: {errors: ["User not logged in"]}, status: :unauthorized
    end
  end

  def create
    user = User.find_by(id: session[:user_id])
    if user
      new_recipe = user.recipes.create!(recipe_params)
      render json: new_recipe, status: :created
    else
      render json: {errors: ["User not logged in"]}, status: :unauthorized
    end
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete, :user_id)
  end

  def render_unprocessable_entity_response(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

end
