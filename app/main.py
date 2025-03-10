from nba_api.stats.static.players import find_players_by_full_name
from nba_api.stats.endpoints import playercareerstats
from fastapi import FastAPI

app = FastAPI()

@app.get('/')
def root():
    return {"home": True}

# name is the players full name
## Returning just pts, reb, ast for now
@app.get('/player_stats/{name}')
def player_stats(name):
    player = find_players_by_full_name(name)
    if player:
        player_id = player[0]['id']
        career = playercareerstats.PlayerCareerStats(player_id=player_id) 
        # headers = career.season_totals_regular_season.data["headers"]
        stats = career.season_totals_regular_season.data["data"][-1]
        gp = int(stats[6]) # games played in the current season

        points = f"{int(stats[26]) / gp:.1f}"
        assists = f"{int(stats[21]) / gp:.1f}"
        rebounds = f"{int(stats[20]) / gp:.1f}"

        return {"ok": True, "result": {"id": player_id, "points":points, "assists": assists, "rebounds": rebounds},}
        # return {"ok": True, "result": {"headers":headers, "stats": stats},}
    else:
        return {"ok": False, "result": f"Could not find player: {name}"}


# name is player full name
# stat is the specifc stat you are looking for (eg points, steals, etc)
@app.get('/player_stats/{name}/{stat}')
def player_stat(name, stat):
    player = find_players_by_full_name(name)
    if player:
        player_id = player[0]['id']
        career = playercareerstats.PlayerCareerStats(player_id=player_id) 
        headers = career.season_totals_regular_season.data["headers"]
        stats = career.season_totals_regular_season.data["data"][-1]

        loc = False
        for i, s in enumerate(headers):
            if stat == s:
                loc = i
                break
                    
        if loc:
            return {"ok":True, stat: f"{(int(stats[loc]) / int(stats[6])):.1f}"}

        else:
            return {"ok": False, "Response": f"Could not find stat: {stat}"}
        
    else:
        return {"ok": False, "Response": f"Could not find player: {name}"}
    
    