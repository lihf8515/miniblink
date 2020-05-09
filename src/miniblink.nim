#====================================================================
#
#              Nim语言的miniblink封装
#
#  这是对miniblink的封装。由于miniblink仅支持windows系统，
#  所以这个封装库也只支持windows系统。
#  
#====================================================================

const dllname = "node.dll"

type
  wkeWindowType* = enum
    WKE_WINDOW_TYPE_POPUP, WKE_WINDOW_TYPE_TRANSPARENT, WKE_WINDOW_TYPE_CONTROL

type
  wkeRect* {.bycopy.} = object
    x*: int
    y*: int
    w*: int
    h*: int

type
  wkeWebFrameHandle* = pointer

type
  wkeNetJob* = pointer

type
  tagWkeWebView* {.bycopy.} = object
  wkeWebView* = ptr tagWkeWebView
  tagWkeString* {.bycopy.} = object
  wkeString* = ptr tagWkeString

type
  wkeCookieVisitor* = proc (params: pointer; name: cstring; value: cstring;
                         domain: cstring; path: cstring; secure: int; httpOnly: int; expires: ptr int): bool {.
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
    x*: int
    y*: int
    width*: int
    height*: int
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
    size*: int
    width*: int
    height*: int
    duration*: float64

type
  wkeProxyType* = enum
    WKE_PROXY_NONE, WKE_PROXY_HTTP, WKE_PROXY_SOCKS4, WKE_PROXY_SOCKS4A,
    WKE_PROXY_SOCKS5, WKE_PROXY_SOCKS5HOSTNAME
  wkeProxy* {.bycopy.} = object
    `type`*: wkeProxyType
    hostname*: array[100, char]
    port*: int
    username*: array[50, char]
    password*: array[50, char]

type
  wkeSettings* {.bycopy.} = object
    proxy*: wkeProxy
    mask*: int

  wkeViewSettings* {.bycopy.} = object
    size*: int
    bgColor*: int

type
  wkeMemBuf* {.bycopy.} = object
    unuse*: int
    data*: pointer
    length*: int

type
  wkeRequestType* = enum
    kWkeRequestTypeInvalidation, kWkeRequestTypeGet, kWkeRequestTypePost,
    kWkeRequestTypePut

type
  wkeHttBodyElementType* = enum
    wkeHttBodyElementTypeData, wkeHttBodyElementTypeFile

type
  wkePostBodyElement* {.bycopy.} = object
    size*: int
    `type`*: wkeHttBodyElementType
    data*: ptr wkeMemBuf
    filePath*: wkeString
    fileStart*: int64
    fileLength*: int64       ##  -1 means to the end of the file.

type
  wkePostBodyElements* {.bycopy.} = object
    size*: int
    element*: ptr ptr wkePostBodyElement
    elementSize*: int
    isDirty*: bool

type
  jsExecState* = pointer

type
  jsValue* = int64

type
  jsType* = enum
    JSTYPE_NUMBER, JSTYPE_STRING, JSTYPE_BOOLEAN, JSTYPE_OBJECT, JSTYPE_FUNCTION,
    JSTYPE_UNDEFINED, JSTYPE_ARRAY, JSTYPE_NULL

type
  jsKeys* {.bycopy.} = object
    length*: int
    keys*: cstringArray

type
  jsGetPropertyCallback* = proc(es: jsExecState, obj: jsValue, propertyName: cstring): jsValue {.cdecl.}

type
  jsSetPropertyCallback* = proc(es: jsExecState, obj: jsValue, propertyName: cstring, value: jsValue): bool {.cdecl.}

type
  jsCallAsFunctionCallback* = proc(es: jsExecState, obj, args: jsValue, argCount: int): jsValue {.cdecl.}

type
  tagjsData* {.bycopy.} = object

type
  jsFinalizeCallback* = proc(data: ptr tagjsData) {.cdecl.}

type
  jsData* {.bycopy.} = object
    typeName*: array[100, char]
    propertyGet*: jsGetPropertyCallback
    propertySet*: jsSetPropertyCallback
    finalize*: jsFinalizeCallback
    callAsFunction*: jsCallAsFunctionCallback

type
  jsExceptionInfo* {.bycopy.} = object
    message*: cstring          ##  Returns the exception message.
    sourceLine*: cstring       ##  Returns the line of source code that the exception occurred within.
    scriptResourceName*: cstring ##  Returns the resource name for the script from where the function causing the error originates.
    lineNumber*: int          ##  Returns the 1-based number of the line where the error occurred or 0 if the line number is unknown.
    startPosition*: int       ##  Returns the index within the script of the first character where the error occurred.
    endPosition*: int         ##  Returns the index within the script of the last character where the error occurred.
    startColumn*: int         ##  Returns the index within the line of the first character where the error occurred.
    endColumn*: int           ##  Returns the index within the line of the last character where the error occurred.
    callstackString*: cstring

type
  wkeTitleChangedCallback* = proc (webView: wkeWebView, param: pointer, title: wkeString) {.cdecl.}

type
  wkeURLChangedCallback* = proc (webView: wkeWebView, param: pointer, url: wkeString) {.cdecl.}

type
  wkeURLChangedCallback2* = proc (webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, url: wkeString) {.cdecl.}

type
  wkePaintUpdatedCallback* = proc (webView: wkeWebView, param: pointer, hdc: int, x, y, cx, cy: int) {.cdecl.}

type
  wkePaintBitUpdatedCallback* = proc (webView: wkeWebView, param: pointer, buffer: pointer, r: wkeRect, width, height: int) {.cdecl.}

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
  wkeConsoleCallback* = proc (webView: wkeWebView, param: pointer, level: wkeConsoleLevel, message, sourceName: wkeString, sourceLine: int, stackTrace: wkeString) {.cdecl.}

type
  wkeCallUiThread* = proc(webView: wkeWebView, param: pointer) {.cdecl.}

type
  wkeLoadUrlBeginCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, job: wkeNetJob) {.cdecl.}

type
  wkeLoadUrlEndCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, job: wkeNetJob, buf: pointer, length: int) {.cdecl.}

type
  wkeDidCreateScriptContextCallback* = proc(webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, context: pointer, extensionGroup, worldId: int) {.cdecl.}

type
  wkeWillReleaseScriptContextCallback* = proc(webView: wkeWebView, param: pointer, frameId: wkeWebFrameHandle, context: pointer, worldId: int) {.cdecl.}

type
  wkeWillMediaLoadCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, info: wkeMediaLoadInfo) {.cdecl.}

type
  wkeWindowClosingCallback* =  proc(webWindow: wkeWebView, param: pointer): bool {.cdecl.}

type
  wkeWindowDestroyCallback* =  proc(webWindow: wkeWebView, param: pointer): bool {.cdecl.}

type
  wkeOnNetGetFaviconCallback* = proc(webView: wkeWebView, param: pointer, url: cstring, buf: wkeMemBuf) {.cdecl.}

type
  jsNativeFunction* = proc(es: jsExecState): jsValue {.fastcall.}

type
  wkeJsNativeFunction* = proc(es: jsExecState, param: pointer): jsValue {.cdecl.}


proc wkeVersion*(): int {.importc, dynlib: dllname, cdecl.}
  ## 获取目前api版本号

proc wkeVersionString*(): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取版本字符串

proc wkeSetWkeDllPath*(dllPath: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置miniblink的全路径+文件名

proc wkeGC*(webView: wkeWebView, delayMs: int) {.importc, dynlib: dllname, cdecl.}
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

proc wkeGetWidth*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取页面宽度

proc wkeGetHeight*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取页面高度

proc wkeGetContentWidth*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取网页排版出来的宽度

proc wkeGetContentHeight*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取网页排版出来的高度

proc wkePaint2*(webView: wkeWebView, bits: pointer, bufWid, bufHei, xDst, yDst, w, h, xSrc, ySrc: int, bCopyAlpha: bool) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息
  ## bits 外部申请并传递给mb的buffer，大小是bufWid * bufHei * 4 字节
  ## bufWid bits的宽
  ## bufHei bits的高
  ## xDst 绘制到bits的哪个坐标
  ## yDst 绘制到bits的哪个坐标
  ## w mb需要取的画面的起始坐标
  ## h mb需要取的画面的起始坐标
  ## xSrc mb需要取的画面的起始坐标
  ## ySrc mb需要取的画面的起始坐标
  ## bCopyAlpha 是否拷贝画面的透明度值
  ## 此函数一般给3d游戏使用。另外频繁使用此接口并拷贝像素有性能问题。最好用wkeGetViewDC再去拷贝dc

proc wkePaint*(webView: wkeWebView, bits: pointer, pitch: int) {.importc, dynlib: dllname, cdecl.}
  ## 获取页面的像素的简化版函数。
  ## bits 外部申请并传递给mb的buffer，大小是webview宽度 * 高度 * 4 字节。
  ## pitch 填0即可。这个参数玩过directX的人应该懂

proc wkeGetViewDC*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取webview的DC

proc wkeGetHostHWND*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取webveiw对应的窗口句柄。实现和wkeGetWindowHandle完全相同 

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

proc wkeSetMediaVolume*(webView: wkeWebView, volume: float) {.importc, dynlib: dllname, cdecl.}
  ## 设置音量，未实现

proc wkeGetMediaVolume*(webView: wkeWebView): float {.importc, dynlib: dllname, cdecl.}
  ## 获取音量，未实现

proc wkeFireMouseEvent*(webView: wkeWebView, message, x, y, flags: int): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送鼠标消息
  ## message可取WM_MOUSELEAVE等Windows相关鼠标消息
  ## flags可取值有WKE_CONTROL、WKE_SHIFT、WKE_LBUTTON、WKE_MBUTTON、WKE_RBUTTON，可通过“或”操作并联

proc wkeFireContextMenuEvent*(webView: wkeWebView, x, y, flags: int): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送菜单消息（未实现）

proc wkeFireMouseWheelEvent*(webView: wkeWebView, x, y, delta, flags: int): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送滚轮消息，用法和参数类似wkeFireMouseEvent。

proc wkeFireKeyUpEvent*(webView: wkeWebView, virtualKeyCode, flags: int, systemKey: bool): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送WM_KEYUP消息
  ## virtualKeyCode见https://msdn.microsoft.com/en-us/library/windows/desktop/dd375731(v=vs.85).aspx
  ## flags可取值有WKE_REPEAT、WKE_EXTENDED，可通过“或”操作并联。

proc wkeFireKeyDownEvent*(webView: wkeWebView, virtualKeyCode, flags: int, systemKey: bool): bool {.importc, dynlib: dllname, cdecl.}
  ## 向mb发送WM_KEYDOWN消息

proc wkeFireWindowsMessag*(webView: wkeWebView, hWnd, message, wParam, lParam, result: int): bool {.importc, dynlib: dllname, cdecl.} 
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

proc wkeSetZoomFactor*(webView: wkeWebView, factor: float) {.importc, dynlib: dllname, cdecl.}
  ## 设置页面缩放系数，默认是1

proc wkeGetZoomFactor*(webView: wkeWebView): float {.importc, dynlib: dllname, cdecl.}
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

proc wkeSetString*(s: wkeString, str: cstring, len: int) {.importc, dynlib: dllname, cdecl.}
  ## 设置wkeString结构体对应的字符串，utf8编码

proc wkeSetStringW*(s: wkeString, str: cstring, len: int) {.importc, dynlib: dllname, cdecl.}
  ## 设置wkeString结构体对应的字符串，utf16编码

proc wkeCreateStringW*(str: cstring, len: int): wkeString {.importc, dynlib: dllname, cdecl.}
  ## 通过utf16编码的字符串，创建一个wkeString

proc wkeDeleteString*(str: wkeString) {.importc, dynlib: dllname, cdecl.}
  ## 析构这个wkeString

proc wkeSetUserKeyValue*(webView: wkeWebView, key: cstring, value: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 对webView设置一个key value键值对。可以用来保存用户自己定义的任何指针

proc wkeGetUserKeyValue*(webView: wkeWebView, key: cstring): pointer {.importc, dynlib: dllname, cdecl.}
  ## 获取webView中指定key的value

proc wkeGetCursorInfoType*(webView: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeCreateWebView*():wkeWebView {.importc, dynlib: dllname, cdecl.}
  ## 创建一个webview，但不创建真窗口。一般用在离屏渲染里，如游戏

proc wkeDestroyWebView*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 效果同wkeDestroyWebWindow

proc wkeCreateWebWindow*(style: wkeWindowType, parent, x, y, width, height: int, cstring=""): wkeWebView {.importc, dynlib: dllname, cdecl.}
  ## 创建一个带真实窗口的wkewkeWebView

proc wkeDestroyWebWindow*(webWindow: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 销毁wkewkeWebView对应的所有数据结构，包括真实窗口等

proc wkeGetWindowHandle*(webWindow: wkeWebView): int {.importc, dynlib: dllname, cdecl.}
  ## 获取窗口对应的真实句柄。和wkeGetHostHWND的实现完全相同 

proc wkeOnWindowClosing*(webWindow: wkeWebView, callback: wkeWindowClosingCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## wkeWebView如果是真窗口模式，则在收到WM_CLODE消息时触发此回调。可以通过在回调中返回false拒绝关闭窗口
  
proc wkeOnWindowDestroy*(webWindow: wkeWebView, callback: wkeWindowDestroyCallback, param: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 窗口即将被销毁时触发回调。不像wkeOnWindowClosing，这个操作无法取消

proc wkeShowWindow*(webWindow: wkeWebView, showFlag: bool) {.importc, dynlib: dllname, cdecl.}
  ## 显示窗口

proc wkeEnableWindow*(webWindow: wkeWebView, enableFlag: bool) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeMoveWindow*(webWindow: wkeWebView, x, y, width, height: int) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeMoveToCenter*(webWindow: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 窗口在父窗口或屏幕里居中

proc wkeResizeWindow*(webWindow: wkeWebView, width, height: int) {.importc, dynlib: dllname, cdecl.}
  ## resize窗口，和wkeResize效果一样 

proc wkeSetWindowTitle*(webWindow: wkeWebView, title: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeSetDeviceParameter*(webView: wkeWebView, device, paramStr: cstring, paramInt: int, paramFloat:float) {.importc, dynlib: dllname, cdecl.}
  ## 设置mb模拟的硬件设备环境。主要用在伪装手机设备场景 

proc wkeInit*() {.importc, dynlib: dllname, cdecl.}
  ## 初始化整个mb。此句必须在所有mb api前最先调用。并且所有mb api必须和调用wkeInit的线程为同个线程 

proc wkeInitialize*() {.importc, dynlib: dllname, cdecl.}
  ## 效果和wkeInit一模一样

proc wkeSetProxy*(proxy: wkeProxy) {.importc, dynlib: dllname, cdecl.}
  ## 设置整个mb的代码。此句是全局生效 

proc wkeSetViewProxy*(webView: wkeWebView, proxy: wkeProxy) {.importc, dynlib: dllname, cdecl.}
  ## 设置整个mb的代码。此句是针对特定webview生效 

proc wkeConfigure*(settings: wkeSettings) {.importc, dynlib: dllname, cdecl.}
  ## 设置一些配置项 

proc wkeIsInitialize*() {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeSetMemoryCacheEnable*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启内存缓存。网页的图片等都会在内存缓存里。关闭后，内存使用会降低一些，但容易引起一些问题，如果不懂怎么用，最好别开 

proc wkeSetTouchEnabled*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启触屏模式。开启后，鼠标消息将自动转换成触屏消息 

proc wkeSetMouseEnabled*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启关闭鼠标消息，可以在开启触屏后，关闭鼠标消息 

proc wkeSetNavigationToNewWindowEnable*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 关闭后，点a标签将不会弹出新窗口，而是在本窗口跳转 

proc wkeSetCspCheckEnable*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 关闭后，跨域检查将被禁止，此时可以做任何跨域操作，如跨域ajax，跨域设置iframe

proc wkeSetNpapiPluginsEnabled*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启关闭npapi插件，如flash 

proc wkeSetHeadlessEnabled*(webView: wkeWebView, b: bool) {.importc, dynlib: dllname, cdecl.}
  ## 开启无头模式。开启后，将不会渲染页面，提升了网页性能

proc wkeSetDebugConfig*(webView: wkeWebView, debugString, param: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 开启一些实验性选项。 
  ## debugString 
  ## "showDevTools"开启开发者工具，此时param要填写开发者工具的资源路径，如file:///c:/miniblink-release/front_end/inspector.html。注意param此时必须是utf8编码
  ## "wakeMinInterval"设置帧率，默认值是10，值越大帧率越低。
  ## "drawMinInterval"设置帧率，默认值是3，值越大帧率越低。
  ## "antiAlias"设置抗锯齿渲染。param必须设置为"1"。
  ## "minimumFontSize"最小字体。
  ## "minimumLogicalFontSize"最小逻辑字体。
  ## "defaultFontSize"默认字体。
  ## "defaultFixedFontSize"默认fixed字体。
  ## "defaultFixedFontSize"默认fixed字体。
  ## "defaultFontSize"默认字体。
  ## "defaultFixedFontSize"默认fixed字体。
  ## "imageEnable" 是否打开无图模式。param为"0"表示开启无图模式
  ## "jsEnable" 是否禁用js。param为"0"表示禁用

proc wkeSetHandle*(webView: wkeWebView, wnd: int) {.importc, dynlib: dllname, cdecl.}
  ## 设置wkeWebView对应的窗口句柄
  ## 只有在无窗口模式下才能使用。如果是用wkeCreateWebWindow创建的webview，已经自带窗口句柄了。

proc wkeSetHandleOffset*(webView: wkeWebView, x, y: int) {.importc, dynlib: dllname, cdecl.}
  ## 设置无窗口模式下的绘制偏移。在某些情况下（主要是离屏模式），绘制的地方不在真窗口的(0, 0)处，就需要手动调用此接口 

proc wkeSetViewSettings*(webView: wkeWebView, settings: wkeViewSettings) {.importc, dynlib: dllname, cdecl.}
  ## 设置一些webview相关的设置。目前只有背景颜色可以设置 

proc wkeSetTransparent*(webView: wkeWebView, transparent: bool) {.importc, dynlib: dllname, cdecl.}
  ## 通知无窗口模式下，wkeWebView开启透明模式

proc wkeIsTransparent*(webView: wkeWebView) {.importc, dynlib: dllname, cdecl.}
  ## 判断窗口是否是分层窗口（layer window） 

proc wkeSetUserAgent*(webView: wkeWebView, userAgent: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 设置webview的UA 

proc wkeSetUserAgentW*(webView: wkeWebView, userAgent: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeGetUserAgent*(webView: wkeWebView): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取webview的UA 

proc wkeLoadURL*(webView: wkeWebView, url: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 加载url。url必须是网络路径，如http://qq.com/

proc wkeLoadW*(webView: wkeWebView, url: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeLoadHTML*(webView: wkeWebView, html: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 加载一段html。如果html里有相对路径，则是相对exe所在目录的路径

proc wkeLoadHtmlWithBaseUrl*(webView: wkeWebView, html, baseUrl: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 加载一段html，但可以指定baseURL，也就是相对于哪个目录的url 

proc wkeLoadFile*(webView: wkeWebView, filename: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 加载文件

proc wkeGetURL*(webView: wkeWebView): cstring {.importc, dynlib: dllname, cdecl.}
  ## 获取webview主frame的url 

proc wkeNetSetHTTPHeaderField*(jobPtr: pointer, key, value: cstring, response: bool) {.importc, dynlib: dllname, cdecl.}
  ## 在wkeOnLoadUrlBegin回调里调用，表示设置http请求（或者file:///协议）的 http header field。response一直要被设置成false 

proc wkeNetSetMIMEType*(jobPtr: pointer, types: cstring) {.importc, dynlib: dllname, cdecl.}
  ## 在wkeOnLoadUrlBegin回调里调用，表示设置http请求的MIME type 

proc wkeNetGetMIMEType*(jobPtr: pointer, mime: wkeString): cstring {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息 

proc wkeNetSetData*(jobPtr, buf: pointer, len: int) {.importc, dynlib: dllname, cdecl.}
  ## 在wkeOnLoadUrlEnd里被调用，表示设置hook后缓存的数据 

proc wkeNetCancelRequest*(jobPtr: pointer) {.importc, dynlib: dllname, cdecl.}
  ## 在wkeOnLoadUrlBegin回调里调用，设置后，此请求将被取消

proc wkeNetGetFavicon*(webView: wkeWebView, callback: wkeOnNetGetFaviconCallback, param: pointer): int {.importc, dynlib: dllname, cdecl.}
  ## 获取favicon。此接口必须在wkeOnLoadingFinish回调里调用

proc wkeNetHoldJobToAsynCommit*(jobPtr: pointer): bool {.importc, dynlib: dllname, cdecl.}
  ## 高级用法。在wkeOnLoadUrlBegin回调里调用。 有时候，wkeOnLoadUrlBegin里拦截到一个请求后，不能马上判断出结果。
  ## 此时可以调用本接口，然后在异步的某个时刻，调用wkeNetContinueJob来让此请求继续进行
  ## TRUE代表成功，FALSE代表调用失败，不能再调用wkeNetContinueJob了

proc wkeNetGetRequestMethod*(jobPtr: pointer): wkeRequestType {.importc, dynlib: dllname, cdecl.}
  ## 获取此请求的method，如post还是get

proc wkeNetGetPostBody*(jobPtr: pointer): wkePostBodyElements {.importc, dynlib: dllname, cdecl.}
  ## 获取此请求中的post数据。只有当请求是post时才有效果

proc wkeNetCreatePostBodyElements*(webView: wkeWebView, length: int): wkePostBodyElements {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeNetFreePostBodyElements*(elements: wkePostBodyElements) {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeNetCreatePostBodyElement*(webView: wkeWebView): wkePostBodyElement {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc wkeNetFreePostBodyElement*(element: wkePostBodyElement) {.importc, dynlib: dllname, cdecl.}
  ## 这四个接口要结合起来使用。 当wkeOnLoadUrlBegin里判断是post时，可以通过wkeNetCreatePostBodyElements来创建一个新的post数据包。 然后wkeNetFreePostBodyElements来释放原post数据

proc jsArgCount*(es: jsExecState): int {.importc, dynlib: dllname, cdecl.}
  ## 获取es里存的参数个数。一般是在绑定的js调用c++回调里使用，判断js传递了多少参数给c++

proc jsArgType*(es: jsExecState, argIdx: int): jsType {.importc, dynlib: dllname, cdecl.}
  ## 判断第argIdx个参数的参数类型。argIdx从是个0开始计数的值。如果超出jsArgCount返回的值，将发生崩溃

proc jsArg*(es: jsExecState, argIdx: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 获取第argIdx对应的参数的jsValue值

proc jsTypeOf*(v: jsValue): jsType {.importc, dynlib: dllname, cdecl.}
  ## 获取v对应的类型

proc jsIsNumber*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 判断v是否为数字

proc jsIsString*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 判断v是否为字符串

proc jsIsBoolean*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 判断v是否为布尔值 

proc jsIsObject*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 判断v是否为对象 

proc jsIsTrue*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 如果v本身是个布尔值，返回对应的true或者false；如果是个对象（JSTYPE_OBJECT），返回false（这里注意）

proc jsIsFalse*(v: jsValue): bool {.importc, dynlib: dllname, cdecl.}
  ## 等价于!jsIsTrue(v) 

proc jsToInt*(es: jsExecState, v: jsValue): int {.importc, dynlib: dllname, cdecl.}
  ## 如果v是个整形或者浮点，返回相应值（如果是浮点，返回取整后的值）。如果是其他类型，返回0（这里注意）

proc jsToDouble*(es: jsExecState, v: jsValue): float64 {.importc, dynlib: dllname, cdecl.}
  ## 如果v是个浮点形，返回相应值。如果是其他类型，返回0.0（这里注意）

proc jsToTempStringW*(es: jsExecState, v: jsValue): cstring {.importc, dynlib: dllname, cdecl.}
  ## 如果v是个字符串，返回相应值。如果是其他类型，返回L""（这里注意） 另外，返回的字符串不需要外部释放。mb会在下一帧自动释放

proc jsToTempString*(es: jsExecState, v: jsValue): cstring {.importc, dynlib: dllname, cdecl.}
  ## 同上

proc jsToString*(es: jsExecState, v: jsValue): cstring {.importc, dynlib: dllname, cdecl.}
  ## 同上，只是返回的是utf8编码

proc jsToStringW*(es: jsExecState, v: jsValue): cstring {.importc, dynlib: dllname, cdecl.}
  ## 暂无接口描述信息

proc jsInt*(n: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 创建建一个int型的jsValue，注意是创建

proc jsString*(es: jsExecState, str: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 构建一个utf8编码的字符串的的jsValue。str会在内部拷贝保存，注意是创建

proc jsArrayBuffer*(es: jsExecState, buffer: cstring, size: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 构建一个js的arraybuffer类型的jaValue。主要用来处理一些二进制数据，注意是创建

proc jsGetArrayBuffer*(es: jsExecState, value: jsValue): wkeMemBuf {.importc, dynlib: dllname, cdecl.}
  ## 获取一个js的arraybuffer类型的数据。主要用来处理一些二进制数据

proc jsEmptyObject*(es: jsExecState): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 构建一个临时js object的jsValue，注意是创建

proc jsEvalW*(es: jsExecState, str: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 执行一段js，并返回值。
  ## str的代码会在mb内部自动被包裹在一个function(){}中。所以使用的变量会被隔离 注意：要获取返回值，请写return。这和wke不太一样。wke不需要写retrun

proc jsEvalExW*(es: jsExecState, str: cstring, isInClosure: bool): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 和上述接口的区别是，isInClosure表示是否要包裹一层function(){}。jsEvalW相当于jsEvalExW(es, str, false)
  ## 如果需要返回值，在isInClosure为true时，需要写return，为false则不用

proc jsCall*(es: jsExecState, function, thisValue: jsValue, args: pointer, argCount: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 调用一个function对应的js函数。如果此js函数是成员函数，则需要填thisValue。 否则可以传jsUndefined。args是个数组，个数由argCount控制。 function可以是从js里取的，也可以是自行构造的

proc jsCallGlobal*(es: jsExecState, function: jsValue, args: pointer, argCount: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 调用window上的全局函数

proc jsGet*(es: jsExecState, obj: jsValue, prop: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 如果obj是个js的object，则获取prop指定的属性。如果obj不是js object类型，则返回jsUndefined

proc jsSet*(es: jsExecState, obj: jsValue, prop: cstring, value: jsValue) {.importc, dynlib: dllname, cdecl.}
  ## 设置obj的属性

proc jsGetGlobal*(es: jsExecState, prop: cstring): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 获取window上的属性

proc jsSetGlobal*(es: jsExecState, prop: cstring, v: jsValue) {.importc, dynlib: dllname, cdecl.}
  ## 设置window上的属性

proc jsGetAt*(es: jsExecState, obj: jsValue, index: int): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 设置js arrary的第index个成员的值，obj必须是js array才有用，否则会返回jsUndefined

proc jsSetAt*(es: jsExecState, obj: jsValue, index: int, value: jsValue) {.importc, dynlib: dllname, cdecl.}
  ## 设置js arrary的第index个成员的值，obj必须是js array才有用

proc jsGetKeys*(es: jsExecState, obj: jsValue): jsKeys {.importc, dynlib: dllname, cdecl.}
  ## 获取obj有哪些key

proc jsGetLength*(es: jsExecState, obj: jsValue): int {.importc, dynlib: dllname, cdecl.}
  ## 获取js arrary的长度，obj必须是js array才有用

proc jsSetLength*(es: jsExecState, obj: jsValue, length: int) {.importc, dynlib: dllname, cdecl.}
  ## 设置js arrary的长度，obj必须是js array才有用

proc jsGetWebView*(es: jsExecState): wkeWebView {.importc, dynlib: dllname, cdecl.}
  ## 获取es对应的webview

proc jsGC*() {.importc, dynlib: dllname, cdecl.}
  ## 强制垃圾回收

proc jsBindFunction*(name: cstring, fn: jsNativeFunction, argCount: int) {.importc, dynlib: dllname, fastcall.}
  ## 绑定一个全局函数到主frame的window上。
  ## 此接口只能绑定主frame，并且特别需要注意的是，因为历史原因，此接口是fastcall调用约定！（但wkeJsBindFunction不是）另外此接口和wkeJsBindFunction必须在webview创建前调用

proc jsBindGetter*(name: cstring, fn: jsNativeFunction) {.importc, dynlib: dllname, cdecl.}
  ## 对js winows绑定一个属性访问器，在js里windows.XXX这种形式调用时，fn会被调用
  ## jsBindGetter("XXX")

proc jsBindSetter*(name: cstring, fn: jsNativeFunction) {.importc, dynlib: dllname, cdecl.}
  ## 对js winows绑定一个属性设置器

proc wkeJsBindFunction*(name: cstring, fn: wkeJsNativeFunction, param: pointer, argCount: int) {.importc, dynlib: dllname, cdecl.}
  ## 和jsBindFunction功能类似，但更方便一点，可以传一个param做自定义数据。
  ## 此接口和wkeJsBindFunction必须在webview创建前调用 

proc jsObject*(es: jsExecState, data: jsData): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 构建一个js Objcet，可以传递给js使用

proc jsFunction*(es: jsExecState, data: jsData): jsValue {.importc, dynlib: dllname, cdecl.}
  ## 创建一个主frame的全局函数。jsData的用法如上。js调用：XXX() 此时jsData的callAsFunction触发。 其实jsFunction和jsObject功能基本类似。且jsObject的功能更强大一些

proc jsGetData*(es: jsExecState, value: jsValue): jsData {.importc, dynlib: dllname, cdecl.}
  ## 获取jsObject或jsFunction创建的jsValue对应的jsData指针

proc jsGetLastErrorIfException*(es: jsExecState): jsExceptionInfo {.importc, dynlib: dllname, cdecl.}
  ## 当wkeRunJs、jsCall等接口调用时，如果执行的js代码有异常，此接口将获取到异常信息。否则返回nullptr
