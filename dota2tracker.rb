require 'sinatra'

get '/' do
    "hello world"
end

get '/last_match' do
<<-HERE
<action>
<app>SurVo</app>
<parameters>
<id>75</id>
<user_parameters>
<first_name>Bill</first_name>
<last_name>Johnson</last_name>
</user_parameters>
<p_t></p_t>
</parameters>
</action>
HERE
end
