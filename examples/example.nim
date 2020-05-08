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
wv.wkeShowWindow(false)
var flagShow = false

proc wkeOnPaintUpdatedCallback(webView: wkeWebView, param: pointer, hdc, x, y, cx, cy: int) {.cdecl.} =
  ## 页面重绘时的回调处理
  if flagShow:
    flagShow = false
    webView.wkeShowWindow(true)
    frame.show()

wv.wkeOnPaintUpdated(wkeOnPaintUpdatedCallback, cast[pointer](frame))

proc wkeDocumentReadyCallback(webView: wkeWebView, param: pointer) {.cdecl.} =
  ## 页面加载完成后的回调处理
  flagShow = true

wv.wkeOnDocumentReady(wkeDocumentReadyCallback, cast[pointer](frame))

proc wkeOnTitleChangedCallBack(webView: wkeWebView, param: pointer, title: wkeString) {.cdecl.} =
  ## 标题改变时的回调处理，注意是给c语言调用的，所以一定要加{.cdecl.}
  frame.title = $webView.wkeGetTitle()

wv.wkeOnTitleChanged(wkeOnTitleChangedCallBack, cast[pointer](frame))

proc wkeOnNavigationCallback(webView: wkeWebView, param: pointer, navigationType: wkeNavigationType, url: wkeString): bool {.cdecl.} =
  ## 页面打开时回调处理
  case $url.wkeGetString()
  of "xcm:close":
    wv.wkeDestroyWebWindow()
    frame.close()
    return false
  else: return true

wv.wkeOnNavigation(wkeOnNavigationCallback, cast[pointer](frame))

app.mainLoop()
