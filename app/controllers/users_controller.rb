class UsersController < ApplicationController

  #users need a :slug, which is a way to customize the url

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  #lets a user sign up
  get '/signup' do
    if !logged_in? #if not logged in
      erb :"users/create_user" #take to create_user page
    else
      redirect to "/tweets" #if they are logged in take them to their tweets
    end
  end

  #gets information from signup form
  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup' #if they left form blank, take to signup again
    else
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])  #create instead of new means eliminating .save
      session[:user_id] = @user.id
      redirect to '/tweets' #take them to their tweets
    end
  end

  #lets user log in
  get '/login' do
    if !logged_in? #if they're not logged in, take them to login page
      erb :'users/login'
    else
      redirect to '/tweets' #if they are lgoged in, take them to their tweets
    end
  end

  #info from log in form
  post "/login" do
     user = User.find_by(username: params[:username])
     if user && user.authenticate(params[:password])
       session[:user_id] = user.id
       redirect to "/tweets"
     else
       redirect to "/signup"
     end
   end

  #log them out
   get '/logout' do
     if logged_in?
       session.destroy
       redirect to '/login'
     else
       redirect to '/'
     end
   end


end
