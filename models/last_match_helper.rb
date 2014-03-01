require './models/steam_helper'
require 'json'

class LastMatchHelper
  attr_reader :steam_helper, :account_id

  def initialize( api_key, account_id )
    @account_id = account_id
    @steam_helper = SteamHelper.new api_key, account_id
  end

  def get_most_recent_match
    JSON.parse( steam_helper.get_matches )['result']['matches'].first
  end

  def get_most_recent_match_details
    match_id = get_most_recent_match_id
    details = JSON.parse( steam_helper.get_match_details( match_id ) )
  end

  def get_some_interesting_information
    player = get_player_info_for_last_match
    hero_name = get_hero_by_id( player['hero_id'] )
    last_hits = get_last_hits_for_last_match
    denies = get_denies_for_last_match
    team = get_team_for_last_match.to_s
    did_i_win = won_most_recent? ? "won" : "lost"
    info = <<-INFO
    You played as #{hero_name}! You had #{last_hits} last hits!
    You had #{denies} denies!
    You were on the #{team} team!
    You #{did_i_win} that match!
    INFO
  end

  private

  def get_most_recent_match_id
    get_most_recent_match['match_id']
  end

  def get_most_recent_hero
    match = get_most_recent_match
    player = match['players'].select{ |p| p['account_id'] == account_id }
    get_hero_by_id( player.first['hero_id'] )
  end

  def won_most_recent?
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
    get_player_info_for_last_match['denies']
  end

  def get_last_hits_for_last_match
    get_player_info_for_last_match['last_hits']
  end

  def get_player_info_for_last_match
    match = get_most_recent_match_details
    player_info = match['result']['players'].select{ |p| p['account_id'] == account_id }[0]
  end

  def get_hero_by_id( id )
    parsed = JSON.parse steam_helper.get_heroes
    heroes = {}
    parsed['result']['heroes'].each do |h|
      heroes[h['id']] = h['name'].gsub('npc_dota_hero_','').gsub('_', ' ')
    end
    
    heroes[id]
  end
end
