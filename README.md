A FiveM resource for seamless Discord integration.
----------
Over Discord is a powerful FiveM resource that utilizes Discord's API to enhance your gaming experience by fetching player information directly from Discord. This resource allows you to access a player’s Discord username, roles, avatar, and more, providing a richer interaction between your server and its community.
Features

- Fetch and display player Discord usernames in-game
- Retrieve and manage player roles for permissions and customizations
- Access player avatars for personalized experiences
- Easy integration with your existing FiveM server setup
- Adding more methods soon!

# Installation

In your `server.cfg` please add the following:

    set discord_token "discord_token_here"
    set discord_guild "discord_guild_id_here"
    
Once done, start your server and you should get a print stating that the authentication was successful; if you do not see this print, ensure that you entered the right discord token and guild ID.

# Methods

```lua
exports["over_discord"]:FetchCache(playerId)
```
Returns the provided players cached discord data
```lua
exports["over_discord"]:DeleteCache(playerId)
```
Deletes the provided players discord cache
```lua
exports["over_discord"]:GetDiscordRoles(playerId)
```
Returns the provided players cached discord roles
```lua
exports["over_discord"]:GetDiscordUsername(playerId)
```
Returns the provided players cached discord username
```lua
exports["over_discord"]:GetDiscordAvatar(playerId)
```
Returns the provided players cached discord avatar

I will be writing more methods in the future, these are the current methods you can use.
