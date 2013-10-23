require 'sinatra'

get '/' do
    "hello world"
end

post '/last_match' do
  params.to_s
end
