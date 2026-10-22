' Flow: home rows -> pick a node -> node splash page -> node video menu -> play.
' When a video ends, the next video in that node's menu plays automatically.
sub init()
    m.rows = m.top.FindNode("rows")
    m.player = m.top.FindNode("player")
    m.splash = m.top.FindNode("splash")
    m.menu = m.top.FindNode("menu")
    m.menuTitle = m.top.FindNode("menuTitle")
    m.menuList = m.top.FindNode("menuList")
    m.menuThumb = m.top.FindNode("menuThumb")
    m.menuDesc = m.top.FindNode("menuDesc")
    m.node = invalid
    m.index = 0
    m.timer = CreateObject("roSGNode", "Timer")
    m.timer.duration = 3
    m.timer.ObserveField("fire", "showMenu")
    m.rows.ObserveField("rowItemSelected", "onSelect")
    m.menuList.ObserveField("itemSelected", "onMenuSelect")
    m.menuList.ObserveField("itemFocused", "onMenuFocus")
    m.player.ObserveField("state", "onPlayerState")
    m.task = CreateObject("roSGNode", "FeedTask")
    m.task.ObserveField("content", "onContent")
    m.task.control = "RUN"
end sub

sub onContent()
    m.rows.content = m.task.content
    m.rows.SetFocus(true)
end sub

' Any tile in a row opens that node
sub onSelect()
    sel = m.rows.rowItemSelected
    m.node = m.rows.content.GetChild(sel[0])
    if m.node = invalid then return
    if m.node.HDPosterUrl <> invalid and m.node.HDPosterUrl <> ""
        m.splash.uri = m.node.HDPosterUrl
        m.splash.visible = true
        m.splash.SetFocus(true)
        m.timer.control = "start"
    else
        showMenu()
    end if
end sub

sub showMenu()
    m.timer.control = "stop"
    m.splash.visible = false
    if m.node = invalid then return
    m.menuTitle.text = m.node.title
    list = CreateObject("roSGNode", "ContentNode")
    for i = 0 to m.node.GetChildCount() - 1
        v = m.node.GetChild(i)
        item = list.CreateChild("ContentNode")
        item.title = v.title
    end for
    m.menuList.content = list
    m.menuList.jumpToItem = 0
    m.menu.visible = true
    m.menuList.SetFocus(true)
    onMenuFocus()
end sub

sub onMenuFocus()
    if m.node = invalid then return
    v = m.node.GetChild(m.menuList.itemFocused)
    if v = invalid then return
    m.menuThumb.uri = v.HDPosterUrl
    m.menuDesc.text = v.description
end sub

sub onMenuSelect()
    playIndex(m.menuList.itemSelected)
end sub

sub playIndex(i as integer)
    if m.node = invalid then return
    if i >= m.node.GetChildCount() then
        closePlayer()
        return
    end if
    v = m.node.GetChild(i)
    if v = invalid or v.url = invalid or v.url = ""
        playIndex(i + 1)
        return
    end if
    m.index = i
    m.menuList.jumpToItem = i
    m.player.content = v
    m.player.visible = true
    m.player.control = "play"
    m.player.SetFocus(true)
end sub

sub onPlayerState()
    if m.player.state = "finished" and m.player.visible
        playIndex(m.index + 1)
    end if
end sub

sub closePlayer()
    m.player.control = "stop"
    m.player.visible = false
    m.menu.visible = true
    m.menuList.SetFocus(true)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    if m.player.visible
        if key = "back"
            closePlayer()
            return true
        end if
    else if m.splash.visible
        if key = "OK"
            showMenu()
            return true
        else if key = "back"
            m.timer.control = "stop"
            m.splash.visible = false
            m.rows.SetFocus(true)
            return true
        end if
    else if m.menu.visible
        if key = "back"
            m.menu.visible = false
            m.rows.SetFocus(true)
            return true
        end if
    end if
    return false
end function
