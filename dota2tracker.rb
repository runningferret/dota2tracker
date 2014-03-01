require 'sinatra'
require './models/last_match_helper'

set :environment, :production

# STEAM_API_KEY = 
get '/' do
  account_id = params['accountid']
  steam_key = params['api_key']
  return "Specify a steam api key(api_key) and 32 bit id(accountid)!" unless account_id && steam_key
  lmh = LastMatchHelper.new(steam_key, account_id.to_i )
  #require 'debugger'; debugger
  #lmh.get_some_interesting_information
end
