# 这是基于wNim和miniblink的一个示例。

import wNim/[wApp, wFrame]
import os
import miniblink

let app = App()
let wndSize = (width:400, height:255)
let frame = Frame(title="", size=wndSize, style=wPopupWindow)
frame.setDoubleBuffered()
frame.center()

wkeInitialize()
var wv: wkeWebView
var wkeWindowStyle = WKE_WINDOW_TYPE_CONTROL
wv = wkeCreateWebWindow(wkeWindowStyle, frame.mHwnd, 0,0,wndSize.width,wndSize.height,"测试")
wv.wkeLoadURL("file:///" & getCurrentDir() & "/html/login.html")
wv.wkeShowWindow(true)

# 标题改变时的回调处理，注意是给c语言调用的，所以一定要加{.cdecl.}
proc wkeOnTitleChangedCallBack(webView: wkeWebView, param: pointer, title: wkeString) {.cdecl.} =
  frame.title = $webView.wkeGetTitle()

wv.wkeOnTitleChanged(wkeOnTitleChangedCallBack, cast[pointer](frame))

# 页面加载完成后的回调处理，显示页面前还是有短暂的白色
proc wkeDocumentReadyCallback(webView: wkeWebView, param: pointer) {.cdecl.} =
  for i in countup(0, 255):
    frame.setTransparent(i)
  frame.show()

wv.wkeOnDocumentReady(wkeDocumentReadyCallback, cast[pointer](frame))

# 页面打开时回调处理
proc wkeOnNavigationCallback(webView: wkeWebView, param: pointer, navigationType: wkeNavigationType, url: wkeString): bool {.cdecl.} =
  case $url.wkeGetString()
  of "xcm:close":
    wv.wkeDestroyWebWindow()
    frame.close()
    return false
  else: return true    

wv.wkeOnNavigation(wkeOnNavigationCallback, cast[pointer](frame))

app.mainLoop()
