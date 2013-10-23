require 'sinatra'

get '/' do
    "hello world"
end

get '/last_match' do
  params.to_s
end
