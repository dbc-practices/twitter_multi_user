require 'debugger'

get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

  username = @access_token.params[:screen_name]
  token = @access_token.token
  secret = @access_token.secret
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  # at this point in the code is where you'll need to create your user account and store the access token
  user = User.where(username: username, oauth_token: token, oauth_secret: secret).first_or_create
  session[:user_id] = user.id
  redirect to '/tweet_it/'
end

get '/tweet_it/' do
  puts session[:user_id]
  @user = User.find(session[:user_id])
  erb :tweet_it
end

post '/tweet_it' do
  user = User.find(session[:user_id])
  CLIENT.access_token = user.oauth_token
  CLIENT.access_token_secret = user.oauth_secret
  tweet = CLIENT.update(params[:tweet])
  tweet.is_a?(Twitter::Tweet) ? "All good!" : "Error!"
end
