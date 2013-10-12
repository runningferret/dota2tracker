require 'steam-condenser'

class SteamHelper

    DOTA2_ID = 570
    
    def initialize( api_key )
        WebApi.api_key = api_key
    end
    
    def get_most_recent_match( account_id )
      JSON.parse( get_matches( account_id ))['result']['matches'].first
    end

    def get_most_recent_hero( account_id )
      match = get_most_recent_match( account_id )
      player = match['players'].select{ |p| p['account_id'] == account_id }
      get_hero_by_id( player.first['hero_id'] )
    end

    def get_most_recent_match_details( account_id )
      match_id = get_most_recent_match_id( account_id )
      details = JSON.parse( get_match_details( match_id ) )
    end

    def get_some_intersting_information( account_id )

    end

    private

    def get_hero_by_id( id )
      parsed = JSON.parse get_heroes
      heroes = {}
      parsed['result']['heroes'].each do |h|
        heroes[h['id']] = h['name'].gsub('npc_dota_hero_','').gsub('_', ' ')
      end
      
      heroes[id]
    end

    def get_match_details( match_id )
      WebApi.json( "IDOTA2Match_#{DOTA2_ID}",
        "GetMatchDetails",
        1,
        match_id: match_id
      )
    end

    def get_matches( account_id )
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

    def get_most_recent_match_id( account_id )
      get_most_recent_match( account_id )['match_id']
    end

    def escape_spaces( string )
        string.gsub!(' ', '%20')
    end
end
