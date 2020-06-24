require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    if Helpers.is_logged_in?(session)
      redirect "/users/#{Helpers.current_user(session).username}"
    else
      erb :index
    end
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect "/tweets"
    else
      erb :signup
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
    else 
      redirect "/signup"
    end
    redirect "/tweets"

  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect "/tweets"
    end
    erb :login
  end

  post '/login' do 
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    end
    redirect "/tweets"
  end

  get '/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
    end
    redirect "/login"
  end

end
