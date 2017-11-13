$(function(){
  $('body').append('fff');
    clientApi.call('clientGetUser', null, {
        success: function(response){
            alert(response['token']);
        }
    });
});
