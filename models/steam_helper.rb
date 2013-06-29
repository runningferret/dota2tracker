require 'steam-condenser'

class SteamHelper

    DOTA2_ID = 570
    
    def initialize( api_key )
        WebApi.api_key = api_key
    end

    def get_matches( player_name )
        WebApi.json( "IDOTA2Match_#{DOTA2_ID}",
            "GetMatchHistory",
            1,
            player_name: escape_spaces( player_name )
        )
    end
    
    private

    def escape_spaces( string )
        string.gsub!(' ', '%20')
    end
end
