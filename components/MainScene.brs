sub init()
    m.rows = m.top.FindNode("rows")
    m.player = m.top.FindNode("player")
    m.splash = m.top.FindNode("splash")
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 3
    m.timer.ObserveField("fire", "playPending")
    m.rows.ObserveField("rowItemSelected", "onSelect")
    m.task = CreateObject("roSGNode", "FeedTask")
    m.task.ObserveField("content", "onContent")
    m.task.control = "RUN"
end sub

sub onContent()
    m.rows.content = m.task.content
    m.rows.SetFocus(true)
end sub

sub onSelect()
    sel = m.rows.rowItemSelected
    item = m.rows.content.GetChild(sel[0]).GetChild(sel[1])
    if item = invalid or item.url = invalid or item.url = "" then return
    m.pending = item
    row = m.rows.content.GetChild(sel[0])
    ' Node splash page shows before the video plays
    if row.HDPosterUrl <> invalid and row.HDPosterUrl <> ""
        m.splash.uri = row.HDPosterUrl
        m.splash.visible = true
        m.timer.control = "start"
    else
        playPending()
    end if
end sub

sub playPending()
    m.splash.visible = false
    m.player.content = m.pending
    m.player.visible = true
    m.player.control = "play"
    m.player.SetFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if press and key = "back" and m.player.visible
        m.player.control = "stop"
        m.player.visible = false
        m.rows.SetFocus(true)
        return true
    end if
    return false
end function
