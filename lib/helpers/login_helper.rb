module Helpers
  module Login
    # Check if the user is currently logged in, and if not, redirect to login page
    def check_login!
      redirect to('/signin.html') unless session[:user]

      User[session[:user]]
    end

    def check_api_login!
      halt 403 unless session[:user]

      User[session[:user]]
    end

    def set_session_user!(user)
      if user
        session[:user] = user.id
      else
        session.delete(:user)
      end
    end
  end
end
