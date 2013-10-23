require 'spec_helper'
require 'steam_helper'

describe SteamHelper do
  let( :api_key )     { :api_key }
  let( :account_id )  { :account_id }
  subject { described_class.new api_key, account_id }

  before :each do
    WebApi.stub( :api_key= )
  end

  describe "#initialize" do
    it "sets the api key on the WebApi" do
      WebApi.
        should_receive( :api_key= ).
        with( :api_key )
      helper = described_class.new( api_key, account_id )
    end
  end

  describe "#get_heroes" do
    it "requests details of all heroes" do
      WebApi.
        should_receive( :json ).
        with( "IEconDOTA2_#{SteamHelper::DOTA2_ID}",
              "GetHeroes",
              1,
            )
      
      subject.get_heroes
    end
  end

  describe "#get_matches" do
    it "requests details of recent matches" do
      WebApi.
        should_receive( :json ).
        with( "IDOTA2Match_#{SteamHelper::DOTA2_ID}",
              "GetMatchHistory",
              1,
              hash_including( :account_id )
            )
      
      subject.get_matches
    end
  end

  describe "#get_account_id_from_steam_name" do
    it "requests details for the specified steam account name" do
      WebApi.
        should_receive( :json ).
        with( "ISteamUser",
              "ResolveVanityURL",
              1,
              hash_including( :vanityurl )
            )
      
      subject.get_account_id_from_steam_name( :name )
    end
  end

  describe "#get_match_details" do
    it "requests details for the specified match" do
      WebApi.
        should_receive( :json ).
        with( "IDOTA2Match_#{SteamHelper::DOTA2_ID}",
              "GetMatchDetails",
              1,
              hash_including( :match_id )
            )
      
      subject.get_match_details( :match_id )
    end
  end
end
