module Helpers
  module Login
    def check_and_get_user
      if session[:user]
        u = User[session[:user]]
        if u
          return u
        else
          # invalid session
          session.delete(:user)
          return nil
        end
      end
      nil
    end

    # Check if the user is currently logged in, and if not, redirect to login page
    def check_login!
      u = check_and_get_user
      redirect to('/signin.html') unless u
      u
    end

    def check_api_login!
      u = check_and_get_user
      halt 403 unless u
      u
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
