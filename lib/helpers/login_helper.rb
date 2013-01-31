module Helpers
  module Login
    # Check if the user is currently logged in, and if not, redirect to login page
    def check_login!
      redirect to('/signin.html') unless session[:user]
    end

    def check_api_login!
      halt 403 unless session[:user]
    end
  end
end
