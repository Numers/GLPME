$(function(){
    clientApi.call('clientGetUser', null, {
        success: function(response){
            alert(response['data']['userInfo']['token']);
        }
    });
});
