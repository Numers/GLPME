Date.prototype.Format = function(fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
};
Array.prototype.min = function(){
    return Math.min.apply(null, this);
}
Array.prototype.max = function(){
    return Math.max.apply(null, this);
}
Array.prototype.remove = function(index){
    if(index > -1) this.splice(index, 1);
    //if(isNaN(index) || index > this.length) return false;
　　//for(var i = 0, n = 0; i < this.length; i++){
　　//　　if(this[i] != this[index]){
　　//　　　　this[n++] = this[i]
　　//　　}
　　//}
　　//this.length -= 1
};
Array.prototype.removeFromValue = function(value){
    var index = this.indexOf(value);
    this.remove(index);
};
Number.prototype.toFixed = function(fractionDigits){
    fractionDigits = parseInt(fractionDigits) || 2;
    return (parseInt(this * Math.pow( 10, fractionDigits  ) + 0.5)/Math.pow(10, fractionDigits)).toString();
}

function ScrollModalboxCallback(event) {
    helper.resetModalboxPosition(event.data.sel, event.data.topOffset, event.data.status);
}

function ScrollEndCallback(event) {
    var totalHeight = parseFloat($(document).height()),
        scrollHeight = parseFloat($(window).scrollTop()) + parseFloat($(window).height());
    if (totalHeight - scrollHeight <= event.data.minTriggerDis) {
        if (typeof event.data.callback == 'function') event.data.callback({
            data: event.data.params,
            end: function() {
                $(window).off('touchmove scroll', ScrollEndCallback);
                show_message_by_client('已全部加载');
            }
        });
    }
}

var helper = {
    isIphone: function() {
        return /iphone|ipad|ipod/i.test(navigator.userAgent);
    },
    isMobile: function() {
        return this.isIphone() || /Android/i.test(navigator.userAgent);
    },
    isWeixn: function() {
        var ua = navigator.userAgent.toLowerCase();
        if (ua.match(/MicroMessenger/i) == 'micromessenger') {
            return true;
        } else {
            return false;
        }
    },
    download: function(url){
        window.open(url);return;
        try{
            // var a = document.createElement('a'),
            //     id = 'a_' + helper.getRandomStr2(8);
            // a.setAttribute('href', url);
            // a.setAttribute('target', '_blank');
            // a.style.display = 'none';
            // a.id = id;
            // document.body.append(a);
            // document.getElement(id).click();
            var id = 'a_' + helper.getRandomStr2(8),
                a = $('<a href="'+url+'" target="_blank" id="'+id+'" style="display:none"></a>');
            $('body').append(a);
            a.get(0).click();
            a.remove();
        }catch(e){
            window.open(url);
        }
    },
    eachData: function(data, callback){
        if($.isArray(data)){
            for(var i = 0; i < data.length; i++) callback(i, data[i]);
        }else{
            for(var i in data) callback(i, data[i]);
        }
    },
    firstCaptital: function(str){
        return str.replace(/(\w)/,function(v){return v.toUpperCase()});
    },
    stopBubbles: function(event, noPrev){
        var e = event || window.event;
        if(e.stopPropagation){
            e.stopPropagation();
        }else if(e){
            e.cancelBubble = true;
        }
        if(!noPrev && e.preventDefault){
            e.preventDefault();
        }
    },
    isIE: function(){
        return /ie/i.test($.browser.name);
    },
    splitKeyword: function(str, k_dot, kv_dot, org_dot){
        str = $.trim(str);
        k_dot = k_dot || ':';
        kv_dot = kv_dot || '#';
        org_dot = org_dot || '%';
        res = [];
        var org = str.split(org_dot);
        for(var i = 0; i < org.length; i++){
            var kv = org[i].split(kv_dot), item = {};
            for(var j = 0; j < kv.length; j++){
                var tmp = kv[j].split(k_dot);
                item[tmp[0]] = tmp[1];
            }
            res.push(item);
        }
        return res;
    },
    showLoaderButton: function(btn_name){
        var className = 'uu-loader-btn', btn = $(btn_name || '.ui.button.submit');
        if(btn.hasClass(className)) return true;
        $('.uu-mask').removeClass('hidden');
        btn.addClass(className);
        return false;
    },
    hideLoaderButton: function(btn_name, delay){
        setTimeout(function(){
            $(btn_name || '.ui.button.submit').removeClass('uu-loader-btn');
            $('.uu-mask').addClass('hidden');
        }, delay || 100);
    },
    showTips: function(classID, text, callback, options){
        var _class = ['normal', 'warning', 'error', 'success'];
        callback = callback || {};
        options = options || {};
        $('.ui.modal._messagebox').find('.ui.message').attr('class', 'ui message ' + _class[classID || 0]).end().find('.header').text(text).end().modal($.extend({
            onShow : function(){
                if(typeof callback['show'] == 'function') callback['show']();

                $('.ui.message .close').off().on('click', function(event){
                    helper.stopBubbles(event);
                    $('.ui.modal._messagebox').modal('hide');
                });
                if(options['closable'] !== false){
                    setTimeout(function(){
                        $('.ui.modal._messagebox').modal('hide');
                    }, 2000);
                }
            },
            onHide: function(){
                if(typeof callback['hide'] == 'function') callback['hide']();
            }
        }, $.extend({allowMultiple: true}, options))).modal('show');
    },
    showLoader: function(text, callback){
        var prop = {
            closable: false,
            onShow: function(){
                if(typeof callback == 'function') callback();
            }
        };
        if(text){
            $('.ui.modal._loader_text').find('.text').text(text).end().modal(prop).modal('show');
        }else{
            $('.ui.modal._loader').modal(prop).modal('show');
        }
    },
    hideTipsAndLoader: function(classID, text, callback){
        helper.showTips(classID, text, {
            hide: function(){
                if(typeof callback == 'function') callback();
                helper.hideLoader();
            }
        });
    },
    // 防止loader框与tips框重合
    delayShowTip: function(classID, text, delay){
        delay = delay || 600;
        setTimeout(function(){
            helper.showTips(classID, text);
        }, delay);
    },
    hideLoader: function(callback){
        var prop = {
            onHidden: function(){
                if(typeof callback == 'function') callback();
            }
        };
        $('.ui.modal._loader_text, .ui.modal._loader').modal(prop).modal('hide');
    },
    showConfirm: function(title, content, btn_cancel, btn_ok, callback, options){
        btn_cancel = (btn_cancel === null)? '' : (btn_cancel || '否');
        btn_ok = btn_ok || '是';
        callback = callback || {};
        options = options || {};
        var selected = options['selected'] || '.ui._confirm',
            box = $(selected);
        delete options['selected'];

        box.find('.header span').text(title).end().find('.content').html(content).end().find('.actions .cancel').text(btn_cancel).end().find('.actions .approve .text').text(btn_ok);
        if(options.btn_status === false) box.find('.actions .ui.button.approve').addClass('disabled');
        if(options['hideBtn'] === true) box.find('.actions').addClass('hide');
        delete options['hideBtn'];
        box.modal($.extend({
            onApprove: function($element){
                if(helper.showLoaderButton(selected + ' .ui.button.approve') === true) return false;
                if(typeof callback['ok'] == 'function') callback['ok']($element);
                return false;
            },
            onDeny: function($element){
                if(typeof callback['cancel'] == 'function') callback['cancel']($element);
                return true;
            },
            onShow: function(){
                if(typeof callback['show'] == 'function') callback['show']();
            },
            onHidden: function(){
                helper.hideLoaderButton(selected + ' .ui.button.approve');
                helper.clearConfirm(selected);
                if(typeof callback['hidden'] == 'function') callback['hidden']();
            }
        }, options)).modal('show');
        box.find('.header .close').off().on('click', function(){
            $(this).closest('.ui.modal').modal('hide');
        });
    },
    clearConfirm: function(selected){ //需要清理，后续的弹框才会执行模板里的脚本
        var box = $(selected);
        box.find('.header span').text('').end().find('.content').html('').end().find('.actions').removeClass('hide');
    },
    hideConfirm: function(selected){
        $(selected || '.ui.modal._confirm').modal('hide');
    },
    hideConfirmLoaderButton: function(selected){
        helper.hideLoaderButton((selected || '.ui.modal._confirm') + ' .ui.button.approve');
    },
    activeConfirmBtn: function(selected){
        $(selected || '.ui.modal._confirm').find('.actions .ui.button.approve').removeClass('disabled');
    },
    showConfirmMulti: function(title, content, btn_cancel, btn_ok, callback, options){
        this.showConfirm(title, content, btn_cancel, btn_ok, callback, $.extend(options, {
            selected: '.ui.modal._confirm_multiple', allowMultiple: true
        }));
    },
    hideConfirmMulti: function(){
        this.hideConfirm('.ui.modal._confirm_multiple');
    },
    hideConfirmMultiLoaderButton: function(){
        this.hideConfirmLoaderButton('.ui.modal._confirm_multiple');
    },
    activeConfirmMultiBtn: function(){
        this.activeConfirmBtn('.ui.modal._confirm_multiple');
    },
    showNotice: function(content){
        $('.uu-notice').removeClass('hide').find('.content').html(content).end().find('.close').off().on('click', function(){
            $(this).closest('.uu-notice').removeClass('show');
            setTimeout(function(){$('.uu-notice').addClass('hide')}, 200);
        });
        setTimeout(function(){$('.uu-notice').addClass('show')}, 200);
    },
    hideNotice: function(){
        $('.uu-notice .close').trigger('click');
    },
    hasAutoSave: function(){
        return !$('.uu-load-bottom').hasClass('hide');
    },
    showAutoSave: function(content){
        $('.uu-load-bottom').removeClass('hide').find('span').text(content);
        setTimeout(function(){$('.uu-load-bottom').addClass('show')}, 200);
    },
    hideAutoSave: function(){
        $('.uu-load-bottom').removeClass('show');
        setTimeout(function(){$('.uu-load-bottom').addClass('hide')}, 200);
    },
    getSuffix: function(filename){
        var pos = filename.lastIndexOf('.'), suffix = '';
        if(pos != -1) suffix = filename.substring(pos);
        return suffix.toLocaleLowerCase();
    },
    isLogin: function(){
        return !!this.dataStorage.get('_token');
    },
    setLogin: function(token){
        this.dataStorage.set('_token', token);
    },
    getToken: function(){
        return this.dataStorage.get('_token') || '';
    },
    logout: function(isError, callback){
        var data = {alert: true};
        if(isError === true){
            show_message_by_client('请重新登录');
            data.alert = false;
        }
        clientApi.call('clientLogout', data, {
            success: function(response){
                if(response['status'] == 1){
                    window.GUserData = {};
                    helper.dataStorage.remove('_token');
                    if(typeof callback == 'function') callback();
                }
            }
        });
    },
    dataStorage: {
        get: function(k){
            var res = null;
            if(!!window.localStorage){
                try{
                    res = JSON.parse(localStorage.getItem(k));
                    if(res['_key_'] !== undefined) res = res['_key_'];
                }catch(e){}
            }else{
                try{
                    // res = JSON.parse($.cookie(k) || '{}');
                    res = JSON.parse($.cookie(k));
                    if(res['_key_'] !== undefined) res = res['_key_'];
                }catch(e){}
            }
            return res;
        },
        set: function(k, v){
            if (!!window.localStorage){
                if(helper.isIphone()){
                    this.remove(k);
                }
                try{
                    if(typeof v != 'object') v = {
                        _key_: v
                    };
                    localStorage.setItem(k, JSON.stringify(v));
                }catch(e){}
            }else{
                try{
                    if(typeof v != 'object') v = {
                        _key_: v
                    };
                    $.cookie(k, JSON.stringify(v), {expires: 7, path: '/'});
                }catch(e){}
            }
        },
        remove: function(k){
            if(!!window.localStorage){
                try{
                    localStorage.removeItem(k);
                }catch(e){}
            }else{
                try{
                    $.removeCookie(k);
                }catch(e){}
            }
        },
        collection: {
            get: function(collName, key){
                var coll = helper.dataStorage.get(collName) || {};
                return key? coll[key] : coll;
            },
            set: function(collName, keyOrMap, value, isDeep){
                var coll = helper.dataStorage.get(collName) || {};
                if($.isPlainObject(keyOrMap)){
                    coll = $.extend(coll, keyOrMap);
                }else{
                    var map = {};
                    map[keyOrMap] = value;
                    isDeep = (typeof isDeep == 'boolean')? isDeep : ($.isPlainObject(value)? true : false);
                    coll = $.extend(isDeep, coll, map);
                }
                helper.dataStorage.set(collName, coll);
                return coll;
            },
            del: function(collName, key){
                var coll = helper.dataStorage.get(collName) || {};
                delete coll[key];
                helper.dataStorage.set(collName, coll);
                return coll;
            },
            clear: function(collName){
                helper.dataStorage.remove(collName);
            }
        }
    },
    isEmail: function(text){
        return /^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$/i.test(text);
    },
    isPhoneNumber: function(text){
        return /^(13[0-9]|14[0-9]|15[0-9]|18[0-9]|17[0-9])\d{8}$/.test(text);
    },
    isTelNumber: function(text){
        return /^0\d{2,3}-?\d{7,8}$/.test(text);
    },
    isPrice: function(value, noZero){
        if(isNaN(value)) return false;
        value = parseFloat(value);
        if(!value && value !== 0) return false;
        if(noZero === true){
            return value > 0;
        }else{
            return value >= 0;
        }
    },
    isDate: function(dateStr){
        dateStr = $.trim(dateStr);
        if(!dateStr) return false;
        var reg = /^(\d{4})-(\d{1,2})-(\d{1,2})$/,
            arr = reg.exec(dateStr);
        if(!arr) return false;
        if(parseInt(arr[2]) > 0 && parseInt(arr[2]) <= 12){
            if(parseInt(arr[3]) > 0 && parseInt(arr[3]) <= this.getDaysInMonth(arr[1], arr[2])){
                return true;
            }
        }
        return false;
    },
    isOnlyMonth: function(dateStr){
        dateStr = $.trim(dateStr);
        if(!dateStr) return false;
        var reg = /^(\d{4})-(\d{1,2})$/,
            arr = reg.exec(dateStr);
        if(!arr) return false;
        if(parseInt(arr[2]) > 0 && parseInt(arr[2]) <= 12){
            return true;
        }
        return false;
    },
    getDaysInMonth: function(year, month){
        month = parseInt(parseInt(month), 10);
        var temp = new Date(parseInt(year), month, 0);
        return temp.getDate();
    },
    monthDiff: function(d1, d2){
        var y1 = d1.getFullYear(),
            y2 = d2.getFullYear(),
            m1 = d1.getMonth() + 1,
            m2 = d2.getMonth() + 1,
            diff = (y2 - y1) * 12 + (m2 - m1);
        return diff;
    },
    toThousands: function(num, len){ //千分位，支持小数位
        len = len || 0;
        num = helper.toDecimal((parseFloat(num) || 0), len).toString();
        var dot = num.replace(/^\d+?\./, '.'), result = '';
        if(num == dot){
            dot = '';
        }else{
            num = num.replace(dot, '');
        }

        while(num.length > 3){
            result = ',' + num.slice(-3) + result;
            num = num.slice(0, num.length - 3);
        }

        if(num) result = num + result;
        return result + dot;
    },
    getObjectKey: function(key, value, arr){
        var res = null;
        for(var i = 0; i < arr.length; i++){
            var item = arr[i];
            if(item[key] == value){
                res = item;
                break;
            }
        }
        return res;
    },
    getObjectLastKey: function(key, value, arr){
        var res = {};
        for(var i = arr.length - 1; i >= 0; i--){
            var item = arr[i];
            if(item[key] == value){
                res = {index: i, item: item};
                break;
            }
        }
        return res;
    },
    getLastObject: function(obj){
        var key = '';
        for(var k in obj){
            key = k;
        }
        return [key, obj[key]];
    },
    compareVersion: function(v1, v2) {
        var _v1 = v1.split('.'),
            _v2 = v2.split('.'),
            res = 0,
            len = _v1.length - _v2.length;
        if (len != 0) {
            if (len > 0) {
                for (var j = 0; j < len; j++) _v2.push(0);
            } else {
                for (var j = 0; j < Math.abs(len); j++) _v1.push(0);
            }
        }
        for (var i in _v1) {
            if (parseInt(_v1[i]) > parseInt(_v2[i])) {
                res = 1;
                break;
            } else if (parseInt(_v1[i]) < parseInt(_v2[i])) {
                res = -1;
                break;
            }
        }
        return res;
    },
    resetModalboxPosition: function(sel, topOffset, status) {
        if (status == 0) {
            $(window).off('touchmove scroll', ScrollModalboxCallback);
        } else {
            topOffset = topOffset || -50;
            var top = $(window).scrollTop() + ($(window).height() / 2),
                modalbox = $('.modalbox' + sel),
                wh = $(window).height(),
                bh = $('body').height(),
                maskHeight = wh > bh ? wh : bh;
            modalbox.find('.wrap,.message').css({
                top: top,
                transform: 'translateY(' + topOffset + '%)',
                '-webkit-transform': 'translateY(' + topOffset + '%)'
            });
            modalbox.find('.mask').height(maskHeight);
            if (status == 1) $(window).on('touchmove scroll', {
                sel: sel,
                topOffset: topOffset,
                status: 2
            }, ScrollModalboxCallback);
        }
    },
    isScrollEnd: function(data) {
        data.minTriggerDis = data.minTriggerDis || 0;
        if (data.isIscroll) {
            function ScrollIEndCallback() {
                if (Math.abs(this.maxScrollY) - Math.abs(this.y) <= data.minTriggerDis) {
                    if (typeof data.callback == 'function') data.callback({
                        data: data.params,
                        end: function() {
                            data.scrollObj.off('scrollEnd', ScrollIEndCallback);
                        }
                    });
                }
            }
            data.scrollObj.on('scrollEnd', ScrollIEndCallback);
        } else {
            $(window).on('touchmove scroll', data, ScrollEndCallback);
        }
    },
    arrayRemoveAt: function(arr, index) {
        if (index > -1) arr.splice(index, 1);
        return arr;
    },
    toDecimal: function(num, len) {
        return (parseFloat(num) || 0).toFixed(len);
    },
    toDecimalABS: function(num, len) {
        if(num < 0){
            num = 0;
        }
        return (parseFloat(num) || 0).toFixed(len);
    },
    getRandom: function(min, max, expend) { //获取大于等于min小于等于max并排除expend的随机整数
        var res = Math.floor(Math.random() * (max - min + 1) + min);
        if (res == expend) {
            return helper.getRandom(min, max, expend);
        } else {
            return res;
        }
    },
    getRandom2: function(n) { //随机一个指定数以内的随机整数
        return Math.floor(Math.random() * n);
    },
    getRandomStr: function(len){
        // return Math.random().toString(36).substr(2);
        len = len || 32;
        var $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
            maxPos = $chars.length, str = '';
        for(i = 0; i < len; i++){
            str += $chars.charAt(Math.floor(Math.random() * maxPos));
        }
        return str;
    },
    getRandomStr2: function(len){
        len = len || 32;
    　　var chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678',
    　　    maxPos = chars.length,
            str = '';
    　　for(i = 0; i < len; i++){
            str += chars.charAt(Math.floor(Math.random() * maxPos));
        }
        return str;
    },
    getRandomRangeStr: function(min, max, flag){
        var str = '', range = min,
            arr = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
        if(flag === true){
            range = Math.round(Math.random() * (max - min)) + min;
        }
        for(var i=0; i<range; i++){
            pos = Math.round(Math.random() * (arr.length-1));
            str += arr[pos];
        }
        return str;
    },
    shockArray: function(arr) {
        arr.sort(function() {
            return Math.random() > .5 ? -1 : 1;
        });
        return arr;
    },
    getParameter: function(k) {
        var q = location.search,
            re = new RegExp('[\?&]' + k + '=([^&]*)(?:&)?', 'i');
        return q.match(re) && q.match(re)[1] || '';
    },
    h5Copy: function(content, callback) {
        var textArea = document.createElement('textarea'),
            result = false;
        textArea.style.position = 'fixed';
        textArea.style.top = 0;
        textArea.style.left = 0;
        textArea.style.width = '1px';
        textArea.style.height = '1px';
        textArea.style.padding = 0;
        textArea.style.border = 'none';
        textArea.style.outline = 'none';
        textArea.style.boxShadow = 'none';
        textArea.style.background = 'transparent';
        textArea.value = content;

        document.body.appendChild(textArea);
        textArea.select();
        try {
            result = document.execCommand('copy') ? true : false;
        } catch (e) {
            result = false;
        }
        // document.body.removeChild(textArea);
        if (typeof callback == 'function') {
            callback(result);
        } else {
            helper.showTips('info', result ? '复制成功' : '请长按复制');
        }
    },
    isUrl: function(str) {
        return /^https?:\/\/\w+/i.test(str);
    },
    removeXSS: function(html) {
        return filterXSS(html || '', {
            whiteList: [],
            stripIgnoreTag: true,
            stripIgnoreTagBody: ['script']
        }).replace(/\[removed\]/, '');
    },
    removeXSS2: function(html, whiteList) {
        return filterXSS($.trim(html || ''), {
            whiteList: $.extend(filterXSS.whiteList, {
                div: ['class'],
                span: ['class', 'style'],
                img: filterXSS.whiteList.img.concat(['class', 'style', 'data-width', 'data-height']),
                video: filterXSS.whiteList.video.concat(['class', 'style', 'data-width', 'data-height'])
            }, whiteList || {}),
            stripIgnoreTag: true,
            stripIgnoreTagBody: ['script'],
            safeAttrValue: function(tag, name, value, cssFilter) {
                value = filterXSS.friendlyAttrValue(value);
                if (name === 'href' || name === 'src') {
                    value = $.trim(value);
                    if (value === '#') return '#';
                    if (!(value.substr(0, 7) === 'http://' || value.substr(0, 8) === 'https://' || value.substr(0, 7) === 'mailto:' || value[0] === '#' || value[0] === '/' || value.substr(0, 9) == 'gj-yxq://')) {
                        return '';
                    }
                    return filterXSS.escapeAttrValue(value);
                } else {
                    return filterXSS.safeAttrValue(tag, name, value, cssFilter);
                }
            }
        }).replace(/\[removed\]/, '');
    },
    removeEmoji: function(content) {
        return (content || '').replace(/^\:[a-z0-9_]+\:$/i, '');
    },
    html: function(content) {
        content = (content || '').replace(/ /igm, ' ').trim();
        return content ? content.replace(/&((g|l|quo)t|amp|#39);/g, function(m) {
            return {
                '<': '<',
                '&': '&',
                '"': '"',
                '>': '>',
                '\'': "'"
            }[m];
        }) : '';
    },
    unhtml: function(content, reg) {
        content = $.trim(content || '');
        return content ? content.replace(reg || /[&<">'](?:(amp|lt|quot|gt|#39|nbsp);)?/g, function(a, b) {
            if (b) {
                return a;
            } else {
                return {
                    '<': '<',
                    '&': '&',
                    '"': '"',
                    '>': '>',
                    "'": '\''
                }[a];
            }
        }) : '';
    },
    strip: function(content) {
        return $.trim(this.html(this.removeXSS(this.removeEmoji(content || ''))));
    },
    strip2: function(content) {
        return $.trim(this.removeXSS(this.removeEmoji(content || '')));
    },
    subContent: function(content, len, suffix){
        content = helper.removeXSS(content || '');
        if(content.length <= len) return content;
        return content.substr(0, len || 20) + (suffix || '...');
    },
    getHeight: function(dom) {
        var h = parseFloat(dom.style.height) || dom.getBoundingClientRect()['height'] || dom.height || dom.offsetHeight;
        if (h > 0) return h;
        return Math.max(dom.scrollHeight, dom.clientHeight, parseFloat(dom.style.height) || 0);
    },
    controlClick: function(sel, callback, that) {
        var _this = $(sel);
        if (_this.hasClass('do')) return;
        _this.addClass('do');
        if (typeof callback == 'function') callback(that ? that : _this);
        setTimeout(function() {
            $(sel).removeClass('do');
        }, 400);
    },
    asynRequest: function(url, data, callback, parameter) {
        callback = callback || {};
        parameter = parameter || {};
        var type = parameter.type || 'POST',
            dataType = parameter.dataType || 'json',
            cache = parameter.cache || false,
            //set application/json; charset=utf-8 for body stream
            contentType = parameter.contentType || 'application/x-www-form-urlencoded',
            headers = parameter.headers || null,
            settings = {
                url: url,
                type: type,
                dataType: dataType,
                cache: cache,
                contentType: contentType,
                data: data,
                beforeSend: function(xhr){
                    if(typeof callback.before == 'function') callback.before(xhr);
                },
                success: function(response, status){
                    if(status == 'success'){
                        if(typeof callback.success == 'function') callback.success(response || {});
                    }else{
                        if(typeof callback.refuse == 'function') callback.refuse(response);
                    }
                },
                complete:function(xhr, status){
                    if(typeof callback.complete == 'function') callback.complete(status);
                },
                error:function(xhr, msg, eThrow){
                    if(typeof callback.error == 'function') callback.error(msg);
                }
            };
        $.ajax(headers ? $.extend(settings, {
            headers: headers
        }) : settings);
    },
    /*
    根据〖中华人民共和国国家标准 GB 11643-1999〗中有关公民身份号码的规定，公民身份号码是特征组合码，由十七位数字本体码和一位数字校验码组成。排列顺序从左至右依次为：六位数字地址码，八位数字出生日期码，三位数字顺序码和一位数字校验码。
        地址码表示编码对象常住户口所在县(市、旗、区)的行政区划代码。
        出生日期码表示编码对象出生的年、月、日，其中年份用四位数字表示，年、月、日之间不用分隔符。
        顺序码表示同一地址码所标识的区域范围内，对同年、月、日出生的人员编定的顺序号。顺序码的奇数分给男性，偶数分给女性。
        校验码是根据前面十七位数字码，按照ISO 7064:1983.MOD 11-2校验码计算出来的检验码。

    出生日期计算方法。
        15位的身份证编码首先把出生年扩展为4位，简单的就是增加一个19或18,这样就包含了所有1800-1999年出生的人;
        2000年后出生的肯定都是18位的了没有这个烦恼，至于1800年前出生的,那啥那时应该还没身份证号这个东东，⊙﹏⊙b汗...
    下面是正则表达式:
     出生日期1800-2099  (18|19|20)?\d{2}(0[1-9]|1[12])(0[1-9]|[12]\d|3[01])
     身份证正则表达式 /^\d{6}(18|19|20)?\d{2}(0[1-9]|1[12])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i
     15位校验规则 6位地址编码+6位出生日期+3位顺序号
     18位校验规则 6位地址编码+8位出生日期+3位顺序号+1位校验位

     校验位规则     公式:∑(ai×Wi)(mod 11)……………………………………(1)
                    公式(1)中：
                    i----表示号码字符从由至左包括校验码在内的位置序号；
                    ai----表示第i位置上的号码字符值；
                    Wi----示第i位置上的加权因子，其数值依据公式Wi=2^(n-1）(mod 11)计算得出。
                    i 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
                    Wi 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2 1

    */
    //身份证号合法性验证
    //支持15位和18位身份证号
    //支持地址编码、出生日期、校验位验证
    isIDCard: function(code){
        var city = {11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江 ",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北 ",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏 ",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"},
            tip = '', pass = true;
        // if(!code || !/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/i.test(code)){
        // if(!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[12])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)){
        // miss 10 since
        if(!code || !/^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$/i.test(code)){
            tip = "身份证号格式错误";
            pass = false;
        }else if(!city[code.substr(0,2)]){
            tip = "地址编码错误";
            pass = false;
        }else{
            //18位身份证需要验证最后一位校验位
            if(code.length == 18){
                code = code.split('');
                //加权因子∑(ai×Wi)(mod 11)
                var factor = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ];
                //校验位
                var parity = [ 1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2 ],
                    sum = 0, ai = 0, wi = 0;
                for(var i = 0; i < 17; i++){
                    ai = code[i];
                    wi = factor[i];
                    sum += ai * wi;
                }
                var last = parity[sum % 11];
                if(parity[sum % 11] != code[17]){
                    tip = "校验位错误";
                    pass =false;
                }
            }
        }
        // if(!pass) console.info(tip);
        return pass;
    },
    isPostCode: function(code){
        return /^[0-9]{6}$/.test(code);
    },
    isUpperCase: function(code){
        return /^[A-Z]{2,6}$/.test(code);
    },
    noEmptyStr: function(str, dot){
        return str? str : (dot || '&nbsp;');
    },
    toBR: function(content){
        return content.replace(/[\r\n]/g, '<br>').replace(/<br><br>/, '<br>');
    }
};

// 模板
if(typeof template == 'function'){
    template.helper('removeXSS', helper.removeXSS);
    template.helper('removeXSS2', helper.removeXSS2);
    template.helper('toDecimal', helper.toDecimal);
    template.helper('toDecimalABS', helper.toDecimalABS);
    template.helper('subContent', helper.subContent);
    template.helper('toThousands', helper.toThousands);
    template.helper('dataFormat', function(time, fmt){
        fmt = fmt || 'yyyy-MM-dd hh:mm:ss';
        if(time){
            return (new Date(time)).Format(fmt);
        }else{
            return '';
        }
    });
    template.helper('noEmptyStr', function(str, dot){
        return helper.noEmptyStr(str, dot);
    });
    template.helper('getLastSet', function(arr, prop){
        return !prop? arr[arr.length - 1] : arr[arr.length - 1][prop];
    });
    template.helper('getRandomStr', function(len){
        return helper.getRandomStr2(len);
    });
    template.helper('renderKeywords', function(keywords, tpl){
        return render_keywords(keywords, tpl);
    });
    template.helper('render_options', function(dictName, defaultName, defaultValue){
        var defaultOption = null;
        if(defaultName) defaultOption = {name: defaultName, value: defaultValue || ''};
        return render_partial({data: GYDict[dictName], defaultOption: defaultOption});
    });
    template.helper('render_partial', function(dictName, partialName){
        return render_partial({data: GYDict[dictName]}, partialName);
    });
    template.helper('toPercentDecimal', function(percent, len){
        return helper.toDecimal(percent * 100, len || 2);
    });
    template.helper('getDictName', function(value, dictName, key){
        var dict =  GYDict[dictName][value];
        if(dict) return key? dict[key] : dict.name;
        return '';
    });
    template.helper('isExistInMap', function(value, map, key, type){
        var item = helper.getObjectKey(key, value, map), res = '';
        if(!item){
            switch(type){
                default: res = ' disabled=disabled';
            }
        }
        return res;
    });
    template.helper('toBR', function(content){
        return helper.toBR(content);
    });
}

// 自定义表单验证
try{
    if($.fn && $.fn.form){
        $.fn.form.settings.rules.loginName = function(value){
            return helper.isEmail(value) || helper.isPhoneNumber(value);
        }
        $.fn.form.settings.rules.isContact = function(value){
            return helper.isPhoneNumber(value) || helper.isTelNumber(value);
        }
        $.fn.form.settings.rules.isPhone = function(value){
            return helper.isPhoneNumber(value);
        }
        $.fn.form.settings.rules.isTel = function(value){
            return helper.isTelNumber(value);
        }
        $.fn.form.settings.rules.isDate = function(value){
            return helper.isDate(value);
        }
        $.fn.form.settings.rules.isOnlyMonth = function(value){
            return helper.isOnlyMonth(value);
        }
        $.fn.form.settings.rules.isPrice = function(value){
            return helper.isPrice(value, true);
        }
        $.fn.form.settings.rules.idcard = function(value){
            return helper.isIDCard(value);
        }
        $.fn.form.settings.rules.postcode = function(value){
            return helper.isPostCode(value);
        }
        $.fn.form.settings.rules.isUpperCase = function(value){
            return helper.isUpperCase(value);
        }
        $.fn.form.settings.rules.isFloat = function(value){
            return helper.isPrice(value);
        }
    }
}catch(e){}
