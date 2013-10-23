require 'steam-condenser'

class SteamHelper
  attr_reader :account_id

  DOTA2_ID = 570
  
  def initialize( api_key, account_id )
      WebApi.api_key = api_key
      @account_id = account_id
  end

  def get_account_id_from_steam_name( name )
    WebApi.json( "ISteamUser",
      "ResolveVanityURL",
      1,
      vanityurl: name
    )
  end 

  def get_match_details( match_id )
    WebApi.json( "IDOTA2Match_#{DOTA2_ID}",
      "GetMatchDetails",
      1,
      match_id: match_id
    )
  end

  def get_matches
    WebApi.json( "IDOTA2Match_#{DOTA2_ID}",
      "GetMatchHistory",
      1,
      account_id: account_id
    )
  end

  def get_heroes
    WebApi.json( "IEconDOTA2_#{DOTA2_ID}",
      "GetHeroes",
      1
    )
  end
end
