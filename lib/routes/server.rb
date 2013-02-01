require 'sinatra/base'

# Module for doing basic redirects and sign in/up/out requests
class CuckooServer < Sinatra::Base
  include Helpers::Url

  get '/' do
    check_login!
    redirect to('/index.html#/home')
  end

  get '/me' do
    check_login!
    redirect to('/index.html#/me')
  end

  get '/users' do
    check_login!
    redirect to('/index.html#/users')
  end

  get '/user/:name' do
    check_login!
    redirect to("/index.html#/user/#{params[:name]}")
  end

  get '/signout' do
    set_session_user! nil
    redirect to('/signin.html')
  end

  post '/signin' do
    u = User.authenticate(params[:login_name], params[:password])
    if u
      set_session_user! u
      redirect to('/')
    else
      redirect to("/signin.html?error=#{encode_uri("Login name or password is incorrect!")}")
    end
  end

  post '/signup' do
    begin
      u = User.create_with_check({login_name: params[:login_name],
                                   password: params[:password],
                                   avatar: params[:avatar],
                                   description: params[:description]})
      set_session_user! u
      redirect to ('/')
    rescue ArgumentError => e
      redirect to("/signup.html?error=#{encode_uri(e.message)}")
    end
  end
end
