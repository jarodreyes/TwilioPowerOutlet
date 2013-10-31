require 'sinatra'
require 'twilio-ruby'
require 'pusher'

before do
  # Setup 
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_KEY']
  Pusher.secret = ENV['PUSHER_SECRET']
end

get '/chaos/' do
  erb :chaos
end

get '/live?*' do
  erb :live
end

get '/trick/?' do
  output = "Our ghoulish ghosts have heard your wish. Happy Halloween! Text 'trick' to see a list of haunted commands."
  begin
    Pusher['trick_channel'].trigger('starting:', {:message => 'starting up trick'})
  rescue Pusher::Error => e
    output = "Failed: #{e.message}"
  end
  # Switch colors
  begin
    command = params['Body'].downcase
    case command
    when 'purple'
      puts Pusher['trick_channel'].trigger('purple', {:message => 'purple'})
    when 'blue'
      puts Pusher['trick_channel'].trigger('blue', {:message => 'blue'})
    when 'red'
      puts Pusher['trick_channel'].trigger('red', {:message => 'red'})
    when 'green'
      puts Pusher['trick_channel'].trigger('green', {:message => 'green'})
    when 'bats'
      puts Pusher['trick_channel'].trigger('bats', {:message => 'go bats'})
    when 'orange'
      puts Pusher['trick_channel'].trigger('orange', {:message => 'orange'})
    when 'chaos'
      puts Pusher['trick_channel'].trigger('chaos', {:message => 'unleash'})
    when 'trick'
      output = "Available Tricks: orange, blue, red, green, purple, trex, sing or chaos."
      end
      puts resp.text
    else
      puts Pusher['trick_channel'].trigger(command, {:message => command})
    end
  rescue
    command = "no message"
  end

  if params['SmsSid'] == nil
    erb :index, :locals => {:msg => output}
  else
    response = Twilio::TwiML::Response.new do |r|
      r.Sms output
    end
    response.text
  end
end

get '/' do
  erb :index, :locals => {:msg => "Haunted Hack"}
end
