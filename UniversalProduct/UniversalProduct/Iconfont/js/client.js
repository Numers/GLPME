document.body.append('vvv');
function setupWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
    if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}
document.body.append('kkk');
var ScriptApi = {
    goBack: function(data){
        history_goback();
    },
    rightAction: function(data){},
    menuClick: function(data){},
    tabBarClick: function(data){},
    openKeyboard: function(data){},
    hideKeyboard: function(data){},
    openMsg: function(data){}
}, clientApi = {
    call: function(apiName, data, callback, times){
        // if(apiName == 'clientGetUser'){
        //     callback['success']({
        //         token: 'N2M5YWZjOWYtMjViYS00MWNiLTlmOTktYzYxMjExMjk2NGY2'
        //     });return;
        // }
        data = data || {};
        callback = callback || {};
        try{
            if(typeof this[apiName] == 'undefined'){
                times = times === undefined ? 10 : times;
                if(times > 0){
                    setTimeout(function(){
                        clientApi.call(apiName, data, callback, times - 1);
                    }, 400);
                }else{
                    throw 'Interface ' + apiName + ' is not found.';
                }
            }else{
                this[apiName](data, callback['success']);
            }
        }catch(e){
            if(typeof callback['failure'] == 'function') callback['failure'](e.message? e.message : e);
        }
    }
};

setupWebViewJavascriptBridge(function(bridge){
    // Client Call JS
                             document.body.append('ttt');
    bridge.registerHandler('goBack', function(data, responseCallback){ //后退
        ScriptApi.goBack(data);
    });
    bridge.registerHandler('setPopViewItemData', function(data, responseCallback){ //顶栏右侧按钮点击
        ScriptApi.rightAction(data);
    });
    bridge.registerHandler('selectMenuItem', function(data, responseCallback){ //侧边栏菜单点击
        ScriptApi.menuClick(data);
    });
    bridge.registerHandler('selectTabBarItem', function(data, responseCallback){ //底栏点击
        ScriptApi.tabBarClick(data);
    });
    bridge.registerHandler('keyboardShow', function(data, responseCallback){ //键盘弹出
        ScriptApi.openKeyboard(data);
    });
    bridge.registerHandler('keyboardHidden', function(data, responseCallback){ //键盘隐藏
        ScriptApi.hideKeyboard(data);
    });
    bridge.registerHandler('setPushInfo', function(data, responseCallback){ //查看消息
        ScriptApi.openMsg(data);
    });

    // JS Call Client
    clientApi.clientSetTopBar = function(data, callback){ //设置顶栏
        bridge.callHandler('setNavigationItem', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientSetSidebar = function(data, callback){ //设置边栏菜单
        bridge.callHandler('setMenuItemData', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientOpenWindow = function(data, callback){ //打开新窗口
        bridge.callHandler('presentWebView', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientSetTabBar = function(data, callback){ //设置底栏
        bridge.callHandler('setTabBar', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientSetTabBarFocus = function(data, callback){ //设置底栏项高亮
        bridge.callHandler('willSelectTabBarItem', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientGetUser = function(data, callback){ //获得用户信息
                             $('body').append('rrr');
        bridge.callHandler('getUserInfo', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientGetInfo = function(data, callback){ //获取客户端信息
        bridge.callHandler('getVersionInfo', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientGoHome = function(data, callback){ //返回首页
        bridge.callHandler('goHome', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientLogout = function(data, callback){ //退出
        bridge.callHandler('loginout', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientFilePreview = function(data, callback){ //文件预览
        bridge.callHandler('filePreviewer', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientPlayVideo = function(data, callback){ //视频播放
        bridge.callHandler('playVideo', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientCallPlatform = function(data, callback){ //电话/QQ/微信
        bridge.callHandler('callPlatform', data, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientGetGeo = function(data, callback){ //地理信息
        bridge.callHandler('getLocation', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientSetProgress = function(data, callback){ //进度条
        bridge.callHandler('setProgress', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientShowMsg = function(data, callback){ //显示系统提示
        bridge.callHandler('showMsg', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
    clientApi.clientCloseWebView = function(data, callback){ //关闭当前webview
        bridge.callHandler('closeWebView', data || {}, function(response){
            if(typeof callback == 'function') callback(response);
        });
    };
});
