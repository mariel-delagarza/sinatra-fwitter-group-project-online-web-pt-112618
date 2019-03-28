require './config/environment'

class ApplicationController < Sinatra::Base

  #by adding enable:sessions and set:sessions_secret, 
  #we allow the use of sessions within the controller 
  #here "secret" is a dummy word  
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions 
    set :session_secret, "secret"
  end
  
  #renders index page, which has login and signup links 
  get '/' do
    erb :index
  end

  #helpers methods are for logging in/checking if someone is logged in.
  
  helpers do
    #the double-bang (!!) operator means the method will return true 
    #unless the block (current_user) is false.
    
    def logged_in?
      !!current_user
    end


    #the current_user method returns the current user if @current_user 
    #is true, otherwise it will set @current user to the user it can 
    #find by the session id.
    
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end
end
