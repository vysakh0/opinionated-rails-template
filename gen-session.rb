class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email])
    if user
        if user.valid_password?(params[:session][:password])
          sign_in user
          render json: {
            session: { id: user.id, email: user.email}
          }
        else
          render json: {
            errors: {
              overall: "invalid password"
            }
          }, status: 420
        end
    else
      render json: {
        errors: {
          overall: "invalid email id"
        }
      }, status: 420
    end

  end

  def destroy
    sign_out :user
    render json: {}
  end

  def password
    @user = User.find_by(email: params[:email])

    if @user
      password_reset
      render json: {
        success: "Email sent successfully"
      }, status: 200

    else
      render json: {
        errors: "invalid email"
      }, status: 420
    end

  end

  def resend_confirmation
    @user = User.find_by(email: params[:email])

    if @user
      @user.send_confirmation_instructions
      render json: {
        success: "Email sent successfully"
      }, status: 200

    else
      render json: {
        errors: "invalid email"
      }, status: 420
    end
  end
  def edit_reset_password
    cookies[:token] = params[:token]
    render "static_pages/index"
  end

  def update_reset_password

    begin
      user = User.find_token_by("password_reset", cookies[:token])
      if user.update(password_params)
        render json: user
       else
        render json: { errors:  user.errors.as_json }, status: 420
      end
    rescue
      render json: {
        errors: {
          overall: "Invalid token"
        }
      }, status: 420
    end
  end

  def password
    user = User.find(params[:id])

    if user.updatea(password: params[:pwd], password_confirmation: params[:pwd])
      EmailDeliverer.perform_async(UserMailer, :admin_reset_pwd, user, params[:pwd])
      render json: {
        success: "Email sent successfully"
      }, status: 200

    else
      render json: {
        errors: "invalid id"
      }, status: 420
    end

  end


  private
  def password_reset
    #UserMailer.delay.reset_password_instructions(@user, reset_url)
    EmailDeliverer.perform_async(UserMailer, :reset_password_instructions, @user, reset_url(@user))
  end

  def password_params
    params.require(:password_reset).permit!
  end
end

