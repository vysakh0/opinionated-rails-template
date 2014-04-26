class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = Omniauth.sign_in(request.env["omniauth.auth"])
    flash.notice = "Signed in!"
    sign_in_and_redirect user
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
  alias_method :google_oauth2, :all
end

