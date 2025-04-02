# RAWG API Documentation

## Base URLs
- Games List: `https://api.rawg.io/api/games`
- Game Details: `https://api.rawg.io/api/games/{id}`

## Authentication
API Key: `fe9d7ddef6394a068e8f6aa7675aacd6`

### List Games
### With Search Query
```bash
curl "https://api.rawg.io/api/games?key=fe9d7ddef6394a068e8f6aa7675aacd6&search=minecraft&page=1&page_size=10" | jq '.'
```

## Sample Games List Response

```json
{
  "count": 471,
  "next": "https://api.rawg.io/api/games?key=fe9d7ddef6394a068e8f6aa7675aacd6&page=2&page_size=10&search=minecraft",
  "previous": null,
  "results": [
    {
      "id": 22509,
      "slug": "minecraft",
      "name": "Minecraft",
      "released": "2011-11-18",
      "background_image": "https://media.rawg.io/media/games/b4e/b4e4c73d5aa4ec66bbf75375c4847a2b.jpg",
      "rating": 4.43,
      "rating_top": 5,
      "ratings_count": 2231,
      "metacritic": 83,
      "playtime": 27,
      "updated": "2023-11-01T11:44:21"
    }
  ]
}

### Get Game Details
```bash
curl -s "https://api.rawg.io/api/games/3498?key=fe9d7ddef6394a068e8f6aa7675aacd6" | jq '.'
```

## Sample Game Details Response

```json
{
  "id": 3498,
  "slug": "grand-theft-auto-v",
  "name": "Grand Theft Auto V",
  "name_original": "Grand Theft Auto V",
  "description": "<p>Rockstar Games went bigger, since their previous installment of the series. You get the complicated and realistic world-building from Liberty City of GTA4 in the setting of lively and diverse Los Santos, from an old fan favorite GTA San Andreas...</p>",
  "metacritic": 92,
  "released": "2013-09-17",
  "tba": false,
  "background_image": "https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg",
  "rating": 4.47,
  "rating_top": 5,
  "ratings": {
    "id": 5,
    "title": "exceptional",
    "count": 4233,
    "percent": 59.01
  },
  "playtime": 74,
  "screenshots_count": 58,
  "movies_count": 8,
  "creators_count": 11,
  "achievements_count": 539,
  "parent_achievements_count": 75,
  "reddit_url": "https://www.reddit.com/r/GrandTheftAutoV/",
  "reddit_name": "",
  "website": "http://www.rockstargames.com/V/",
  "metacritic_url": "https://www.metacritic.com/game/pc/grand-theft-auto-v"
}
```

## Notes
- Always include the API key in your requests
- Use URL encoding for special characters in the search query
- The API returns results in JSON format
- For game details, replace {id} with the actual game ID in the URL