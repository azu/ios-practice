jQuery(function($){
    $('table.docutils').addClass('table table-striped table-bordered');
    $('table.docutils').removeClass('docutils');

    $('.admonition').addClass('alert alert-block');
    $('.admonition.note').addClass('alert-info');
    $('.admonition.warning').addClass('alert-error');
});
jQuery(function($){
    // options によっては存在しない
    if(!$('#live-reload')){
        return;
    }

    function disableButton(){
        $('#live-reload').addClass("disabled");
    }
    var autoReload = function(){
        if (autoReload.timer){
            clearInterval(autoReload.timer);
            $("#live-reload").removeClass("disabled")
            return;
        }
        disableButton();
        var content = {};
        autoReload.timer = setInterval(function(){
            var req = new XMLHttpRequest();
            req.open("GET", location.href, true);
            req.onload = function(){
                if (content.old && req.responseText != content.old){
                    location.reload();
                }
                content.old = req.responseText;
            };
            req.send(null);
        }, 1000);
    };
    $('#live-reload').click(function(){
        autoReload();
    });
    // exports
    if(typeof window.okfn === 'undefined'){
        window.okfn = {};
    }
    window.okfn.autoReload = autoReload;

});