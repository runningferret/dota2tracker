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
      last_hits = get_last_hits_for_last_match
      denies = get_denies_for_last_match
      team = get_team_for_last_match.to_s
      did_i_win = get_did_i_win ? "won" : "lost"
      puts "*"*100
      puts "You played as #{hero_name}!"
      puts "You had #{last_hits} last_hits!"
      puts "You had #{denies} denies!"
      puts "You were on the #{team} team!"
      puts "You #{did_i_win} that match!"
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
    
    def get_did_i_win
      res = get_most_recent_match_details
      winning_team = res['result']['radiant_win'] ? :radiant : :dire

      return winning_team == get_team_for_last_match
    end

    def get_team_for_last_match
      player = get_player_info_for_last_match
      slot = player['player_slot']
      return ((slot.to_s(2).to_i & 10000000) != 0) ? :dire : :radiant
    end

    def get_denies_for_last_match
      player = get_player_info_for_last_match
      player['denies']
    end

    def get_last_hits_for_last_match
      player = get_player_info_for_last_match
      player['last_hits']
    end

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
