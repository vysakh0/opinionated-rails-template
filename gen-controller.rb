class Api::V1::UsersController < ApplicationController
  respond_to :json

  def create
    user = User.new(user_params)
    user.password = "1234~abcd"
    user.password_confirmation = "1234~abcd"

    if user.save
      user.confirm!
      render json: user, status: :created
    else
      render json: { errors:  user.errors.as_json }, status: 420
    end
  end

  def destroy
  end

  def show
    render json: User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if check_user && @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  def current
    if current_user
      render json: current_user
    else
      render json: {}
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def check_user
    current_user == @user
  end

end

