module OmniauthProcess
  #extend ActiveSupport::Concern

  class CommonOmniauth

    def initialize(auth)
      @uid            = auth[:uid]
      @email          = auth[:info][:email]
      @name           = auth[:info][:name]
      @provider       = auth[:provider]
    end

    def omniauth_user
      existing_auth || build_auth
    end

    def existing_auth
      omniauth = Omniauth.where(provider: @provider, uid: @uid).take
      omniauth.user if omniauth
    end

    def build_auth
      user = find_or_create_user
      user.omniauths.build(provider: @provider, uid: @uid)
      user.save
      user
    end

    def find_or_create_user
      User.find_by(email: @email) || new_user
    end

    def new_user
      user = User.new(name: @name, email: @email)
      #user.confirm!
      user
    end

  end

  class FacebookOmniauth < CommonOmniauth
  end

  class GoogleOmniauth < CommonOmniauth
  end

end

