require 'steam_helper'

describe SteamHelper do

    subject { described_class.new :api_key }

    before :each do
        WebApi.stub( :api_key= )
    end

    describe "#initialize" do
        it "sets the api key on the WebApi" do
            WebApi.
                should_receive( :api_key= ).
                with( :an_api_key )
            helper = described_class.new( :an_api_key )
        end
    end

    describe "#get_matches" do
        let( :player_name ) { 'unicorn farts' }
        it "gets matches" do
            WebApi.
                should_receive( :json ).
                with( "IDOTA2Match_#{SteamHelper::DOTA2_ID}",
                "GetMatchHistory",
                1,
                player_name: player_name
            )
            subject.get_matches( player_name )
        end
    end
end
