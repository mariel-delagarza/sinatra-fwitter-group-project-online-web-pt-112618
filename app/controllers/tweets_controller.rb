class TweetsController < ApplicationController

  #Per the instructions, we need 2 controller actions.
  #one to load the create tweet form, and one to process
  #the form submission

  #if the user is logged_in, this will get their tweets
  #if they are not, it will take them to log in.

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :"tweets/tweets"
    else
      redirect to "/login" #this is the form to log in
    end
  end

  #if the user is logged_in, this will let them draft
  #a new tweet. if they are not, it will take them
  #to log in.

  get '/tweets/new' do
    if logged_in?
      erb :"tweets/new" #this is the form to make a tweet
    else
      redirect to '/login'
    end
  end

  #this takes the information from the create-tweet form
  post '/tweets' do
    if logged_in?  #checks if user is logged in
      if params[:content] == "" #if they didn't write a tweet,
       redirect to "/tweets/new" #it sends them back to the create-form
      else
        @tweet = current_user.tweets.build(content: params[:content])
        #using .build is because the User has_many tweets
        if @tweet.save #if the tweet can be saved,
          redirect to "/tweets/#{@tweet.id}" #send them to the page for that tweet
        else
          redirect to "/tweets/new" #otherwise, take them back to the page to make a new tweet
        end
      end
    else
      redirect to "/login"
    end
  end

  #this lets the user view a single tweet
  get '/tweets/:id' do
    if logged_in? #they have to be logged in
      @tweet = Tweet.find_by_id(params[:id]) #find the tweet by ID
      erb :"tweets/show_tweet" #render the show tweet page
    else
      redirect to "/login" #if they're not logged in, take them to login
    end
  end

  #this takes the user to the page to edit tweets
  get '/tweets/:id/edit' do
    if logged_in? #they have to be logged_in
      @tweet = Tweet.find_by_id(params[:id]) #find the tweet by id
      if @tweet && @tweet.user == current_user #tweet has to match user
        erb :"tweets/edit_tweet" #page to edit tweets
      else
        redirect to "/tweets" #take them back to tweets page
      end
    else
      redirect to "/login" #make them log in
    end
  end

  #patch is the action used to update [the form has to be
  #submitted via POST but id="hidden" will say patch]
  patch '/tweets/:id' do #update a specific tweet
    if logged_in? #user must be logged in
      if params[:content] == "" #if the tweet content is empty
        redirect to "/tweets/#{params[:id]}/edit" #redirect to the edit page
      else
        @tweet = Tweet.find_by_id(params[:id]) #find the tweet
        if @tweet && @tweet.user == current_user #if tweet/user match
          if @tweet.update(content: params[:content]) #update with content from form
            redirect to "/tweets/#{@tweet.id}" #send back to tweet page
          else
            redirect to "/tweets/#{@tweet.id}/edit" #send back to edit
          end
        else
          redirect to "/tweets" #send back to all tweets
        end
      end
    else
      redirect to '/login' #if not logged in, send to log in page
    end
  end

  #delete a single tweet
  delete '/tweets/:id/delete' do
    if logged_in? #must be logged in
      @tweet = Tweet.find_by_id(params[:id]) #find the tweet by id
      if @tweet && @tweet.user == current_user #user and tweet must match
        @tweet.delete #delete the tweet
      end
      redirect to "/tweets" #take them back to their tweets
    else
      redirect to "/login" #take them to log in page
    end
  end
end
