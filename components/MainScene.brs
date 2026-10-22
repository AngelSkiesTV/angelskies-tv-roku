sub init()
    m.rows = m.top.FindNode("rows")
    m.player = m.top.FindNode("player")
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
    m.player.content = item
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
