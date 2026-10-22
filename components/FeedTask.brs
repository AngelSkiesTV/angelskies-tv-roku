sub init()
    m.top.functionName = "load"
end sub

' Each node becomes its own row
sub load()
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetUrl(GetConfig().FEED_URL)
    feed = ParseJson(xfer.GetToString())
    root = CreateObject("roSGNode", "ContentNode")
    if feed <> invalid
        for each n in feed.nodes
            row = root.CreateChild("ContentNode")
            row.title = n.title
            if n.splash <> invalid then row.HDPosterUrl = n.splash
            if n.videos.Count() = 0
                v = row.CreateChild("ContentNode")
                v.title = "Coming soon"
            else
                for each vid in n.videos
                    v = row.CreateChild("ContentNode")
                    v.title = vid.title
                    v.description = vid.description
                    v.HDPosterUrl = vid.thumbnail
                    v.url = vid.url
                    v.streamFormat = vid.streamFormat
                end for
            end if
        end for
    end if
    m.top.content = root
end sub
