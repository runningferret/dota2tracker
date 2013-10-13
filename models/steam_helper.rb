require 'steam-condenser'

class SteamHelper
    attr_reader :account_id

    DOTA2_ID = 570
    
    def initialize( api_key, account_id )
        WebApi.api_key = api_key
        @account_id = account_id
    end
    
    def get_most_recent_match
      JSON.parse( get_matches )['result']['matches'].first
    end

    def get_most_recent_hero
      match = get_most_recent_match
      player = match['players'].select{ |p| p['account_id'] == account_id }
      get_hero_by_id( player.first['hero_id'] )
    end

    def get_most_recent_match_details
      match_id = get_most_recent_match_id
      details = JSON.parse( get_match_details( match_id ) )
    end

    def get_some_interesting_information
      player = get_player_info_for_last_match
      hero_name = get_hero_by_id( player['hero_id'] )
      puts "*"*100
      puts "You played as #{hero_name}"
      puts "*"*100
    end

    def get_account_id_from_steam_name( name )
      WebApi.json( "ISteamUser",
        "ResolveVanityURL",
        1,
        vanityurl: name
      )
    end 

    private

    def get_player_info_for_last_match
      match = get_most_recent_match_details
      player_info = match['result']['players'].select{ |p| p['account_id'] == account_id }[0]
    end

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

    def get_most_recent_match_id
      get_most_recent_match['match_id']
    end

    def escape_spaces( string )
        string.gsub!(' ', '%20')
    end
end
