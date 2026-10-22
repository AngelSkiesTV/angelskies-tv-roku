' Change FEED_URL to the Cloudflare node-feed endpoint once the backend is live
function GetConfig() as object
    return { FEED_URL: "https://raw.githubusercontent.com/AngelSkiesTV/angelskies-tv-roku/main/feed/feed.json" }
end function
