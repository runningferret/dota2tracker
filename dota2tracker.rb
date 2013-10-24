require 'sinatra'
require './models/last_match_helper'

get '/' do
  account_id = params['accountid']
  lmh = LastMatchHelper.new( "DF08597129E71A0EBF7A2FA880A437CD", account_id.to_i )
  lmh.get_some_interesting_information
end

get '/last_match', :provides => ['xml'] do
<<-HERE
<action>
<app>findme</app>
<parameters>
<id>708204</id>
<user_parameters>
<first_name>Bill</first_name>
<last_name>Johnson</last_name>
</user_parameters>
<p_t></p_t>
</parameters>
</action>
HERE
end
