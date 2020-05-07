#====================================================================
#
#              Nim语言的miniblink封装
#
#  这只是对miniblink的简单封装，有一部分接口尚未封装进来。
#  
#====================================================================

when defined(windows):
  const dllname = "node.dll"
elif defined(macosx):
  const dllname = "node.dylib"
else:
  const dllname = "node.so"

type
  wkeWindowType* = enum
    WKE_WINDOW_TYPE_POPUP, WKE_WINDOW_TYPE_TRANSPARENT, WKE_WINDOW_TYPE_CONTROL

type
  wkeRect* {.bycopy.} = object
    x*: cint
    y*: cint
    w*: cint
    h*: cint

type
  jsExecState* = pointer

type
  wkeWebFrameHandle* = pointer

type
  wkeNetJob* = pointer

type
  jsValue* = int64

type
  tagWkeWebView* {.bycopy.} = object
  wkeWebView* = ptr tagWkeWebView
  tagWkeString* {.bycopy.} = object
  wkeString* = ptr tagWkeString

type
  wkeCookieVisitor* = proc (params: pointer; name: cstring; value: cstring;
                         domain: cstring; path: cstring; secure: cint; httpOnly: cint; expires: ptr cint): bool {.
      cdecl.} ##  If |path| is non-empty only URLs at or below the path will get the cookie value.
             ##  If |secure| is true the cookie will only be sent for HTTPS requests.
             ##  If |httponly| is true the cookie will only be sent for HTTP requests.
  ##  The cookie expiration date is only valid if |has_expires| is true.

type
  wkeNavigationType* = enum
    WKE_NAVIGATION_TYPE_LINKCLICK, WKE_NAVIGATION_TYPE_FORMSUBMITTE,
    WKE_NAVIGATION_TYPE_BACKFORWARD, WKE_NAVIGATION_TYPE_RELOAD,
    WKE_NAVIGATION_TYPE_FORMRESUBMITT, WKE_NAVIGATION_TYPE_OTHER

type
  wkeCookieCommand* = enum
    wkeCookieCommandClearAllCookies, wkeCookieCommandClearSessionCookies,
    wkeCookieCommandFlushCookiesToFile, wkeCookieCommandReloadCookiesFromFile

type
  wkeWindowFeatures* {.bycopy.} = object
    x*: cint
    y*: cint
    width*: cint
    height*: cint
    menuBarVisible*: bool
    statusBarVisible*: bool
    toolBarVisible*: bool
    locationBarVisible*: bool
    scrollbarsVisible*: bool
    resizable*: bool
    fullscreen*: bool

type
  wkeConsoleLevel* = enum
    wkeLevelLog = 1, wkeLevelWarning = 2, wkeLevelError = 3, wkeLevelDebug = 4,
    wkeLevelInfo = 5, wkeLevelRevokedError = 6

const
  wkeLevelLast = wkeLevelInfo

type
  wkeMediaLoadInfo* {.bycopy.} = object
    size*: cint
    width*: cint
    height*: cint
    duration*: cdouble



type
  wkeTitleChangedCallback* = proc (webView: wkeWebView, param: pointer, title: wkeString) {.cdecl.}

type
  wkeURLChangedCallback* = proc (webView: wkeWebView, param: pointer, url: wkeString) {.cdecl.}

type
  wkeURLChangedCallback2* = proc (webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, url: wkeString) {.cdecl.}

type
  wkePaintUpdatedCallback* = proc (webView: wkeWebView, param: pointer, hdc: cint, x, y, cx, cy: cint) {.cdecl.}

type
  wkePaintBitUpdatedCallback* = proc (webView: wkeWebView, param: pointer, buffer: pointer, r: wkeRect, width, height: cint) {.cdecl.}

type
  wkeAlertBoxCallback* = proc (webView: wkeWebView, param: pointer, msg: wkeString) {.cdecl.}

type
  wkeConfirmBoxCallback* = proc (webView: wkeWebView, param: pointer, msg: wkeString) {.cdecl.}

type
  wkePromptBoxCallback* = proc (webView: wkeWebView, param: pointer, msg, defaultResult, result: wkeString) {.cdecl.}

type
  wkeNavigationCallback* = proc (webView: wkeWebView, param: pointer, navigationType: wkeNavigationType, url: wkeString): bool {.cdecl.}

type
  wkeCreateViewCallback* = proc (webView: wkeWebView, param: pointer, navigationType: wkeNavigationType, url: wkeString, windowFeatures: wkeWindowFeatures) {.cdecl.}

type
  wkeDocumentReadyCallback* = proc (webView: wkeWebView, param: pointer) {.cdecl.}

type
  wkeDocumentReady2Callback* = proc (webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle) {.cdecl.}

type
  wkeDownloadCallback* = proc (webView: wkeWebView, param: pointer, url: cstring) {.cdecl.}

type
  wkeNetResponseCallback* = proc (webView: wkeWebView, param: pointer, url: cstring, job: wkeNetJob) {.cdecl.}

type
  wkeConsoleCallback* = proc (webView: wkeWebView, param: pointer, level: wkeConsoleLevel, message, sourceName: wkeString, sourceLine: cuint, stackTrace: wkeString) {.cdecl.}

type
  wkeCallUiThread* = proc(webView: wkeWebView, param: pointer) {.cdecl.}

type
  wkeLoadUrlBeginCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, job: wkeNetJob) {.cdecl.}

type
  wkeLoadUrlEndCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, job: wkeNetJob, buf: pointer, length: cint) {.cdecl.}

type
  wkeDidCreateScriptContextCallback* = proc(webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, context: pointer, extensionGroup, worldId: cint) {.cdecl.}

type
  wkeWillReleaseScriptContextCallback* = proc(webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, context: pointer, worldId: cint) {.cdecl.}

type
  wkeWillMediaLoadCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, info: wkeMediaLoadInfo) {.cdecl.}




proc wkeVersion*(): cuint {.importc, dynlib: dllname, cdecl.}
  ## 获取目前api版本号

proc wkeVersionString*(): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取版本字符串

proc wkeSetWkeDllPath*(dllPath: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置miniblink的全路径+文件名

proc wkeGC*(webView: wkeWebView, delayMs: cint) {.importc, dynlib: dllname, cdecl.}
  ## 延迟让miniblink垃圾回收

proc wkeEnableHighDPISupport*() {.importc, dynlib: dllname, cdecl.}
  ## 开启高分屏支持。注意，这个api内部是通过设置ZOOM，并且关闭系统默认放大来实现。所以再使用wkeGetZoomFactor会发现值可能不为1

proc wkeIsDocumentReady*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## DOM文档结构是否加载完成

proc wkeStopLoading*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 停止加载页面
  
proc wkeReload*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 重新加载页面

proc wkeGetTitle*(webView: wkeWebView): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取页面标题

proc wkeResize*(webView: wkeWebView, width, height: int) {.importc, dynlib: dllname, cdecl.}
  ## 重新设置页面的宽高。如果wkeWebView是带窗口模式的，会设置真窗口的宽高

proc wkeGetWidth*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 获取页面宽度

proc wkeGetHeight*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 获取页面高度

proc wkeGetContentWidth*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 获取网页排版出来的宽度

proc wkeGetContentHeight*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 获取网页排版出来的高度

proc wkeGetViewDC*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 获取webview的DC

proc wkeCanGoBack*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## 页面是否可以后退

proc wkeGoBack*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## 强制让页面后退

proc wkeCanGoForward*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## 页面是否可以前进

proc wkeGoForward*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## 强制让页面前进

proc wkeEditorSelectAll*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 给webview发送全选命令

proc wkeEditorUnSelect*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 给webview发送取消命令

proc wkeEditorCopy*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 拷贝页面里被选中的字符串

proc wkeEditorCut*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 剪切页面里被选中的字符串

proc wkeEditorDelete*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 清除剪切板中字符串

proc wkeEditorUndo*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 暂无描述信息

proc wkeEditorRedo*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 暂无描述信息

proc wkeGetCookieW*(webView: wkeWebView): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取页面的cookie
  
proc wkeGetCookie*(webView: wkeWebView): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取页面的cookie

proc wkeSetCookie*(webView: wkeWebView, url: cstring, cookie: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置页面cookie。
  ## cookie必须符合curl的cookie写法。一个例子是：PERSONALIZE=123;expires=Monday, 13-Jun-2022 03:04:55 GMT; domain=.fidelity.com; path=/; secure

proc wkeVisitAllCookie*(params: pointer, visitor: wkeCookieVisitor) {.importc, dynlib: dllname, cdecl.}
  ## 通过访问器visitor访问所有cookie。

proc wkePerformCookieCommand*(webView: wkeWebView, command: wkeCookieCommand) {.importc, dynlib: dllname, cdecl.}
  ## 通过设置mb内置的curl来操作cookie。这个接口只是调用curl设置命令，并不会去修改js里的内容

proc wkeSetCookieEnabled*(webView: wkeWebView, enable: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启或关闭cookie。这个接口只是影响blink，并不会设置curl。所以还是会生成curl的cookie文件

proc wkeIsCookieEnabled*(webView: wkeWebView): bool {.importc, dynlib: dllname, cdecl.}
  ## 是否允许cookie

proc wkeSetCookieJarPath*(webView: wkeWebView, path: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置cookie的本地文件目录。默认是当前目录。cookies存在当前目录的“cookie.dat”里

proc wkeSetCookieJarFullPath*(webView: wkeWebView, path: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置cookie的全路径+文件名，如c:\mb\cookie.dat

proc wkeSetLocalStorageFullPath*(webView: wkeWebView, path: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置local storage的全路径。如“c:\mb\LocalStorage\cookie.dat”,这个接口只能接受目录。

proc wkeSetMediaVolume*(webView: wkeWebView, volume: cfloat) {.importc, dynlib: dllname, cdecl.}
  ## 设置音量，未实现

proc wkeGetMediaVolume*(webView: wkeWebView): cfloat {.importc, dynlib: dllname, cdecl.}
  ## 获取音量，未实现

proc wkeFireMouseEvent*(webView: wkeWebView, message: cuint, x, y: cint, flags: cuint): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送鼠标消息
  ## message可取WM_MOUSELEAVE等Windows相关鼠标消息
  ## flags可取值有WKE_CONTROL、WKE_SHIFT、WKE_LBUTTON、WKE_MBUTTON、WKE_RBUTTON，可通过“或”操作并联

proc wkeFireContextMenuEvent*(webView: wkeWebView, x, y: cint, flags: cuint): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送菜单消息（未实现）

proc wkeFireMouseWheelEvent*(webView: wkeWebView, x, y, delta: cint, flags: cuint): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送滚轮消息，用法和参数类似wkeFireMouseEvent。

proc wkeFireKeyUpEvent*(webView: wkeWebView, virtualKeyCode, flags: cuint, systemKey: bool): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送WM_KEYUP消息
  ## virtualKeyCode见https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
  ## flags可取值有WKE_REPEAT、WKE_EXTENDED，可通过“或”操作并联。

proc wkeFireKeyDownEvent*(webView: wkeWebView, virtualKeyCode, flags: cuint, systemKey: bool): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送WM_KEYDOWN消息

proc wkeFireWindowsMessag*(webView: wkeWebView, hWnd: cint, message: cuint, wParam: cuint, lParam: cint, result: cint): bool {.importc, dynlib: dllname, cdecl.} 
  ## 向mb发送任意windows消息。不过目前mb主要用来处理光标相关。mb在无窗口模式下，要响应光标事件，需要通过本函数手动发送光标消息

proc wkeSetFocus*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 设置webview是焦点态。如果webveiw关联了窗口，窗口也会有焦点

proc wkeKillFocus*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeGetCaretRect*(webView: wkeWebView): wkeRect {.importc, dynlib: dllname, cdecl.}
  ## 获取编辑框的那个游标的位置

proc wkeRunJS*(webView: wkeWebView, script: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 运行一段js。返回js的值jsValue。jsValue是个封装了内部v8各种类型的类，如果需要获取详细信息，有jsXXX相关接口可以调用。

proc wkeRunJSW*(webView: wkeWebView, script: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 同上。注意，此函数以及wkeRunJS，执行的js，也就是script，是在一个闭包中

proc wkeGlobalExec*(webView: wkeWebView): jsExecState {.importc, dynlib: dllname, cdecl.}
  ## 获取页面主frame的jsExecState。

proc wkeSleep*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 暂未实现

proc wkeWake*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeIsAwake*(webView: wkeWebView):bool {.importc, dynlib: dllname, cdecl.}
  ## 暂未实现

proc wkeSetZoomFactor*(webView: wkeWebView, factor: cfloat) {.importc, dynlib: dllname, cdecl.}
  ## 设置页面缩放系数，默认是1

proc wkeGetZoomFactor*(webView: wkeWebView): cfloat {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeSetEditable*(webView: wkeWebView, editable: bool) {.importc, dynlib: dllname, cdecl.}
  ## 未实现

proc wkeOnTitleChanged*(webView: wkeWebView, callback: wkeTitleChangedCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 设置标题变化的通知回调

proc wkeOnMouseOverUrlChanged*(webView: wkeWebView, callback: wkeTitleChangedCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 鼠标划过的元素，如果是，则调用此回调，并发送a标签的url

proc wkeOnURLChanged*(webView: wkeWebView, callback: wkeURLChangedCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## url改变回调

proc wkeOnURLChanged2*(webView: wkeWebView, callback: wkeURLChangedCallback2, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 和上个接口不同的是，回调多了个参数frameId,表示frame的id。有相关接口可以判断这个frameId是否是主frame

proc wkeOnPaintUpdated*(webView: wkeWebView, callback: wkePaintUpdatedCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 页面有任何需要刷新的地方，将调用此回调。

proc wkeOnPaintBitUpdated*(webView: wkeWebView, callback: wkePaintBitUpdatedCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 同上。不同的是回调过来的是填充好像素的buffer，而不是DC。方便嵌入到游戏中做离屏渲染

proc wkeOnAlertBox*(webView: wkeWebView, callback: wkeAlertBoxCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 网页调用alert会走到这个接口填入的回调

proc wkeOnConfirmBox*(webView: wkeWebView, callback: wkeConfirmBoxCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeOnPromptBox*(webView: wkeWebView, callback: wkePromptBoxCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeOnNavigation*(webView: wkeWebView, callback: wkeNavigationCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 网页开始浏览将触发回调。
  ## callback定义为 wkeNavigationCallback* = proc (webView: wkeWebView, param: pointer, navigationType: wkeNavigationType, url: cstring)
  ## wkeNavigationType表示浏览触发的原因。
  ## 可以取的值有：WKE_NAVIGATION_TYPE_LINKCLICK：点击a标签触发。WKE_NAVIGATION_TYPE_FORMSUBMITTE：点击form触发。
  ## WKE_NAVIGATION_TYPE_BACKFORWARD：前进后退触发。WKE_NAVIGATION_TYPE_RELOAD：重新加载触发
  ## wkeNavigationCallback回调的返回值，如果是true，表示可以继续进行浏览，false表示阻止本次浏览。

proc wkeOnCreateView*(webView: wkeWebView, callback: wkeCreateViewCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 网页点击a标签创建新窗口时将触发回调

proc wkeOnDocumentReady*(webView: wkeWebView, callback: wkeDocumentReadyCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 对应js里的body onload事件

proc wkeOnDocumentReady2*(webView: wkeWebView, callback: wkeDocumentReady2Callback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 同上。区别是wkeDocumentReady2Callback多了wkeWebFrameHandle frameId参数。可以判断是否是主frame

proc wkeOnDownload*(webView: wkeWebView, callback: wkeDownloadCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 页面下载事件回调。点击某些链接，触发下载会调用

proc wkeNetOnResponse*(webView: wkeWebView, callback: wkeNetResponseCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 一个网络请求发送后，收到服务器response触发回调

proc wkeOnConsole*(webView: wkeWebView, callback: wkeConsoleCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 网页调用console触发

proc wkeSetUIThreadCallback*(webView: wkeWebView, callback: wkeCallUiThread, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 暂时未实现

proc wkeOnLoadUrlBegin*(webView: wkeWebView, callback: wkeLoadUrlBeginCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 任何网络请求发起前会触发此回调
  ## 1，此回调功能强大，在回调里，如果对job设置了wkeNetHookRequest，则表示mb会缓存获取到的网络数据，并在这次网络请求 结束后调用wkeOnLoadUrlEnd设置的回调，
  ##    同时传递缓存的数据。在此期间，mb不会处理网络数据。
  ## 2，如果在wkeLoadUrlBeginCallback里没设置wkeNetHookRequest，则不会触发wkeOnLoadUrlEnd回调。
  ## 3，如果wkeLoadUrlBeginCallback回调里返回true，表示mb不处理此网络请求（既不会发送网络请求）。返回false，表示mb依然会发送网络请求。

proc wkeOnLoadUrlEnd*(webView: wkeWebView, callback: wkeLoadUrlEndCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 见wkeOnLoadUrlBegin的描述

proc wkeOnDidCreateScriptContext*(webView: wkeWebView, callback: wkeDidCreateScriptContextCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## javascript的v8执行环境被创建时触发此回调。每个frame创建时都会触发此回调

proc wkeOnWillReleaseScriptContext*(webView: wkeWebView, callback: wkeWillReleaseScriptContextCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 每个frame的javascript的v8执行环境被关闭时触发此回调

proc wkeOnWillMediaLoad*(webView: wkeWebView, callback: wkeWillMediaLoadCallback, callbackParam: pointer) {.importc, dynlib: dllname, cdecl.}
  ## video等多媒体标签创建时触发此回调

proc wkeIsMainFrame*(webView: wkeWebView, frameId: wkeWebFrameHandle) {.importc, dynlib: dllname, cdecl.}
  ## 判断frameId是否是主frame

proc wkeWebFrameGetMainFrame*(webView: wkeWebView): wkeWebFrameHandle {.importc, dynlib: dllname, cdecl.}
  ## 获取主frame的句柄

proc wkeRunJsByFrame*(webView: wkeWebView, frameId: wkeWebFrameHandle, script: cstring, isInClosure: bool): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 运行js在指定的frame上，通过frameId。
  ## isInClosure表示是否在外层包个function() {}形式的闭包
  ## 如果需要返回值，在isInClosure为true时，需要写return，为false则不用

proc wkeGetFrameUrl*(webView: wkeWebView, frameId: wkeWebFrameHandle): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取frame对应的url

proc wkeGetString*(s: wkeString): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取wkeString结构体对应的字符串，utf8编码

proc wkeGetStringW*(s: wkeString): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取wkeString结构体对应的字符串，utf16编码

proc wkeSetString*(s: wkeString, str: cstring, len: csize_t) {.importc, dynlib: dllname, cdecl.}
  ## 设置wkeString结构体对应的字符串，utf8编码

proc wkeSetStringW*(s: wkeString, str: cstring, len: csize_t) {.importc, dynlib: dllname, cdecl.}
  ## 设置wkeString结构体对应的字符串，utf16编码

proc wkeCreateStringW*(str: cstring, len: csize_t): wkeString {.importc, dynlib: dllname, cdecl.}
  ## 通过utf16编码的字符串，创建一个wkeString

proc wkeDeleteString*(str: wkeString) {.importc, dynlib: dllname, cdecl.}
  ## 析构这个wkeString

proc wkeSetUserKeyValue*(webView: wkeWebView, key: cstring, value: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 对webView设置一个key value键值对。可以用来保存用户自己定义的任何指针

proc wkeGetUserKeyValue*(webView: wkeWebView, key: cstring): pointer {.importc, dynlib: dllname, cdecl.}
  ## 获取webView中指定key的value

proc wkeGetCursorInfoType*(webView: wkeWebView): cint {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeMoveToCenter*(webWindow: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 窗口在父窗口或屏幕里居中
 

# 初始化控件
proc wkeInitialize*() {.importc, dynlib: dllname, cdecl.}
# 创建一个带真实窗口的wkewkeWebView
proc wkeCreateWebWindow*(style: wkeWindowType, parent:int, x, y, width, height: int, cstring=""): wkeWebView {.importc, dynlib: dllname, cdecl.}
# 销毁wkewkeWebView对应的所有数据结构，包括真实窗口等
proc wkeDestroyWebWindow*(webWindow: wkeWebView) {.importc, dynlib: dllname, cdecl.}
# 加载url。url必须是网络路径，如http://qq.com/
proc wkeLoadURL*(webView: wkeWebView, url: cstring) {.importc, dynlib: dllname, cdecl.}
# 加载一段html。如果html里有相对路径，则是相对exe所在目录的路径
proc wkeLoadHTML*(webView: wkeWebView, html: cstring) {.importc, dynlib: dllname, cdecl.}
proc wkeLoadFile*(webView: wkeWebView, filename: cstring) {.importc, dynlib: dllname, cdecl.}
proc wkeShowWindow*(webWindow: wkeWebView, showFlag: bool) {.importc, dynlib: dllname, cdecl.}
# 创建一个wkeWebView，但不创建真窗口。一般用在离屏渲染里，如游戏
proc wkeCreateWebView*():wkeWebView {.importc, dynlib: dllname, cdecl.}
proc wkeSetHandle*(webView: wkeWebView, wnd: cint) {.importc, dynlib: dllname, cdecl.}
proc wkeDestroyWebView*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
# 通知无窗口模式下，wkeWebView开启透明模式
proc wkeSetTransparent*(webView: wkeWebView, transparent: bool) {.importc, dynlib: dllname, cdecl.}


