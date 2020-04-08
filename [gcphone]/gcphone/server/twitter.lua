local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPgc = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRP._prepare("TwitterGetTweets", [===[
  SELECT twitter_tweets.*,
    twitter_accounts.username as author,
    twitter_accounts.avatar_url as authorIcon
  FROM twitter_tweets
    LEFT JOIN twitter_accounts
    ON twitter_tweets.authorId = twitter_accounts.id
  ORDER BY time DESC LIMIT 130
  ]===])

vRP._prepare("TwitterGetTweets2", [===[
    SELECT twitter_tweets.*,
      twitter_accounts.username as author,
      twitter_accounts.avatar_url as authorIcon,
      twitter_likes.id AS isLikes
    FROM twitter_tweets
      LEFT JOIN twitter_accounts
        ON twitter_tweets.authorId = twitter_accounts.id
      LEFT JOIN twitter_likes 
        ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
    ORDER BY time DESC LIMIT 130
  ]===])

function TwitterGetTweets(accountId, cb)
    if accountId == nil then
        cb(vRP.query("TwitterGetTweets", {}))
    else
        cb(vRP.query("TwitterGetTweets2", {accountId = accountId}))
    end
end

vRP._prepare("TwitterGetFavotireTweets", [===[
  SELECT twitter_tweets.*,
    twitter_accounts.username as author,
    twitter_accounts.avatar_url as authorIcon
  FROM twitter_tweets
    LEFT JOIN twitter_accounts
      ON twitter_tweets.authorId = twitter_accounts.id
  WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
  ORDER BY likes DESC, TIME DESC LIMIT 30
]===])
vRP._prepare("TwitterGetFavotireTweets2", [===[
  SELECT twitter_tweets.*,
    twitter_accounts.username as author,
    twitter_accounts.avatar_url as authorIcon,
    twitter_likes.id AS isLikes
  FROM twitter_tweets
    LEFT JOIN twitter_accounts
      ON twitter_tweets.authorId = twitter_accounts.id
    LEFT JOIN twitter_likes 
      ON twitter_tweets.id = twitter_likes.tweetId AND twitter_likes.authorId = @accountId
  WHERE twitter_tweets.TIME > CURRENT_TIMESTAMP() - INTERVAL '15' DAY
  ORDER BY likes DESC, TIME DESC LIMIT 30
]===])
function TwitterGetFavotireTweets(accountId, cb)
    if accountId == nil then
        cb(vRP.query("TwitterGetFavotireTweets", {}))
    else
        cb(vRP.query("TwitterGetFavotireTweets2", {accountId = accountId}))
    end
end

vRP._prepare("getUser",
             "SELECT id, username as author, avatar_url as authorIcon FROM twitter_accounts WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password")
function getUser(username, password, cb)
    local data =
        vRP.query("getUser", {username = username, password = password})
    cb(data[1])
end

vRP._prepare("TwitterPostTweet",
             "INSERT INTO twitter_tweets (`authorId`, `message`, `realUser`) VALUES(@authorId, @message, @realUser); SELECT * from twitter_tweets WHERE id = (SELECT LAST_INSERT_ID());")
function TwitterPostTweet(username, password, message, sourcePlayer, realUser,
                          cb)
    getUser(username, password, function(user)
        if user == nil then
            if sourcePlayer ~= nil then
                TwitterShowError(sourcePlayer, 'Twitter Info',
                                 'APP_TWITTER_NOTIF_LOGIN_ERROR')
            end
            return
        end

        local tweets = vRP.query("TwitterPostTweet", {
            authorId = user.id,
            message = message,
            realUser = realUser
        })

        local tweet = tweets[1]
        tweet['author'] = user.author
        tweet['authorIcon'] = user.authorIcon
        TriggerClientEvent('gcPhone:twitter_newTweets', -1, tweet)
        TriggerEvent('gcPhone:twitter_newTweets', tweet)

    end)
end

vRP._prepare("TwitterToogleLike", "SELECT * FROM twitter_tweets WHERE id = @id")
vRP._prepare("TwitterToogleLike2",
             "SELECT * FROM twitter_likes WHERE authorId = @authorId AND tweetId = @tweetId")
vRP._prepare("TwitterToogleLike3",
             "INSERT INTO twitter_likes (`authorId`, `tweetId`) VALUES(@authorId, @tweetId)")
vRP._prepare("TwitterToogleLike4",
             "UPDATE `twitter_tweets` SET `likes`= likes + 1 WHERE id = @id")
vRP._prepare("TwitterToogleLike5", "DELETE FROM twitter_likes WHERE id = @id")
vRP._prepare("TwitterToogleLike6",
             "UPDATE `twitter_tweets` SET `likes`= likes - 1 WHERE id = @id")
function TwitterToogleLike(username, password, tweetId, sourcePlayer)
    getUser(username, password, function(user)
        if user == nil then
            if sourcePlayer ~= nil then
                TwitterShowError(sourcePlayer, 'Twitter Info',
                                 'APP_TWITTER_NOTIF_LOGIN_ERROR')
            end
            return
        end
        local tweets = vRP.query('TwitterToogleLike', {id = tweetId})

        if (tweets[1] == nil) then return end
        local tweet = tweets[1]
        local row = vRP.query('TwitterToogleLike2',
                              {authorId = user.id, tweetId = tweetId})

        if (row[1] == nil) then
            vRP.execute('TwitterToogleLike3',
                        {authorId = user.id, tweetId = tweetId})
            vRP.execute('TwitterToogleLike4', {id = tweet.id})

            TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id,
                               tweet.likes + 1)
            TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer,
                               tweet.id, true)
            TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id,
                         tweet.likes + 1)
        else
            vRP.execute('TwitterToogleLike5', {id = row[1].id})
            vRP.execute('TwitterToogleLike6', {id = tweet.id})
            TriggerClientEvent('gcPhone:twitter_updateTweetLikes', -1, tweet.id,
                               tweet.likes - 1)
            TriggerClientEvent('gcPhone:twitter_setTweetLikes', sourcePlayer,
                               tweet.id, false)
            TriggerEvent('gcPhone:twitter_updateTweetLikes', tweet.id,
                         tweet.likes - 1)
        end
    end)
end

vRP._prepare("TwitterCreateAccount",
             "INSERT IGNORE INTO twitter_accounts (`username`, `password`, `avatar_url`) VALUES(@username, @password, @avatarUrl); SELECT LAST_INSERT_ID() AS id;")
function TwitterCreateAccount(username, password, avatarUrl, cb)
    local data = vRP.query('TwitterCreateAccount', {
        username = username,
        password = password,
        avatarUrl = avatarUrl
    })
    cb(data[1].id)
end
-- ALTER TABLE `twitter_accounts`	CHANGE COLUMN `username` `username` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci';

function TwitterShowError(sourcePlayer, title, message)
    TriggerClientEvent('gcPhone:twitter_showError', sourcePlayer, message)
end
function TwitterShowSuccess(sourcePlayer, title, message)
    TriggerClientEvent('gcPhone:twitter_showSuccess', sourcePlayer, title,
                       message)
end

RegisterServerEvent('gcPhone:twitter_login')
AddEventHandler('gcPhone:twitter_login', function(username, password)
    local sourcePlayer = tonumber(source)
    getUser(username, password, function(user)
        if user == nil then
            TwitterShowError(sourcePlayer, 'Twitter Info',
                             'APP_TWITTER_NOTIF_LOGIN_ERROR')
        else
            TwitterShowSuccess(sourcePlayer, 'Twitter Info',
                               'APP_TWITTER_NOTIF_LOGIN_SUCCESS')
            TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer,
                               username, password, user.authorIcon)
        end
    end)
end)

vRP._prepare("twitter_changePassword",
             "UPDATE `twitter_accounts` SET `password`= @newPassword WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password")
RegisterServerEvent('gcPhone:twitter_changePassword')
AddEventHandler('gcPhone:twitter_changePassword',
                function(username, password, newPassword)
    local sourcePlayer = tonumber(source)
    getUser(username, password, function(user)
        if user == nil then
            TwitterShowError(sourcePlayer, 'Twitter Info',
                             'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
        else
            local result = vRP.execute("twitter_changePassword", {
                username = username,
                password = password,
                newPassword = newPassword
            })
            if (result == 1) then
                TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer,
                                   username, newPassword, user.authorIcon)
                TwitterShowSuccess(sourcePlayer, 'Twitter Info',
                                   'APP_TWITTER_NOTIF_NEW_PASSWORD_SUCCESS')
            else
                TwitterShowError(sourcePlayer, 'Twitter Info',
                                 'APP_TWITTER_NOTIF_NEW_PASSWORD_ERROR')
            end
        end
    end)
end)

RegisterServerEvent('gcPhone:twitter_createAccount')
AddEventHandler('gcPhone:twitter_createAccount',
                function(username, password, avatarUrl)
    local sourcePlayer = tonumber(source)
    TwitterCreateAccount(username, password, avatarUrl, function(id)
        if (id ~= 0) then
            TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer,
                               username, password, avatarUrl)
            TwitterShowSuccess(sourcePlayer, 'Twitter Info',
                               'APP_TWITTER_NOTIF_ACCOUNT_CREATE_SUCCESS')
        else
            TwitterShowError(sourcePlayer, 'Twitter Info',
                             'APP_TWITTER_NOTIF_ACCOUNT_CREATE_ERROR')
        end
    end)
end)

RegisterServerEvent('gcPhone:twitter_getTweets')
AddEventHandler('gcPhone:twitter_getTweets', function(username, password)
    local sourcePlayer = tonumber(source)
    if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
        getUser(username, password, function(user)
            local accountId = user and user.id
            TwitterGetTweets(accountId, function(tweets)
                TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer,
                                   tweets)
            end)
        end)
    else
        TwitterGetTweets(nil, function(tweets)
            TriggerClientEvent('gcPhone:twitter_getTweets', sourcePlayer, tweets)
        end)
    end
end)

RegisterServerEvent('gcPhone:twitter_getFavoriteTweets')
AddEventHandler('gcPhone:twitter_getFavoriteTweets',
                function(username, password)
    local sourcePlayer = tonumber(source)
    if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
        getUser(username, password, function(user)
            local accountId = user and user.id
            TwitterGetFavotireTweets(accountId, function(tweets)
                TriggerClientEvent('gcPhone:twitter_getFavoriteTweets',
                                   sourcePlayer, tweets)
            end)
        end)
    else
        TwitterGetFavotireTweets(nil, function(tweets)
            TriggerClientEvent('gcPhone:twitter_getFavoriteTweets',
                               sourcePlayer, tweets)
        end)
    end
end)

RegisterServerEvent('gcPhone:twitter_postTweets')
AddEventHandler('gcPhone:twitter_postTweets',
                function(username, password, message)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    TwitterPostTweet(username, password, message, sourcePlayer, srcIdentifier)
end)

RegisterServerEvent('gcPhone:twitter_toogleLikeTweet')
AddEventHandler('gcPhone:twitter_toogleLikeTweet',
                function(username, password, tweetId)
    local sourcePlayer = tonumber(source)
    TwitterToogleLike(username, password, tweetId, sourcePlayer)
end)

vRP._prepare("twitter_setAvatarUrl",
             "UPDATE `twitter_accounts` SET `avatar_url`= @avatarUrl WHERE twitter_accounts.username = @username AND twitter_accounts.password = @password")
RegisterServerEvent('gcPhone:twitter_setAvatarUrl')
AddEventHandler('gcPhone:twitter_setAvatarUrl',
                function(username, password, avatarUrl)
    local sourcePlayer = tonumber(source)
    local result = vRP.execute("twitter_setAvatarUrl", {
        username = username,
        password = password,
        avatarUrl = avatarUrl
    })
    if (result == 1) then
        TriggerClientEvent('gcPhone:twitter_setAccount', sourcePlayer, username,
                           password, avatarUrl)
        TwitterShowSuccess(sourcePlayer, 'Twitter Info',
                           'APP_TWITTER_NOTIF_AVATAR_SUCCESS')
    else
        TwitterShowError(sourcePlayer, 'Twitter Info',
                         'APP_TWITTER_NOTIF_LOGIN_ERROR')
    end
end)

--[[
  Discord WebHook
  set discord_webhook 'https//....' in config.cfg
--]]
AddEventHandler('gcPhone:twitter_newTweets', function(tweet)
    -- --print(json.encode(tweet))
    local discord_webhook = GetConvar('discord_webhook', '')
    if discord_webhook == '' then return end
    local headers = {['Content-Type'] = 'application/json'}
    local data = {
        ["username"] = tweet.author,
        ["embeds"] = {
            {
                ["thumbnail"] = {["url"] = tweet.authorIcon},
                ["color"] = 1942002,
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", tweet.time / 1000)
            }
        }
    }
    local isHttp = string.sub(tweet.message, 0, 7) == 'http://' or
                       string.sub(tweet.message, 0, 8) == 'https://'
    local ext = string.sub(tweet.message, -4)
    local isImg = ext == '.png' or ext == '.pjg' or ext == '.gif' or
                      string.sub(tweet.message, -5) == '.jpeg'
    if (isHttp and isImg) and true then
        data['embeds'][1]['image'] = {['url'] = tweet.message}
    else
        data['embeds'][1]['description'] = tweet.message
    end
    PerformHttpRequest(discord_webhook, function(err, text, headers) end,
                       'POST', json.encode(data), headers)
end)
