// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  $('.img-thumbnail').each(function() {
    return LoadImage(this);
  });

  $('#find-video').on('click', function(e) {
    var url, $button;
    e.preventDefault();
    url = window.location.href;
    $button = $(this);

    $button.attr('disabled','disabled');
    $.post(url, function(data) {
      $('.top-right').notify({
         message: { text: data.app.notice.text }
      }).show();
    })
    .done(function() {
      $button.removeAttr('disabled');
    });
  });
});

function LoadImage(image) {
  var img = new Image(),
    data = image.dataset;

  if(data.src) {
    img.onload = function() {
      image.src = img.src;
    };

    img.src = data.src;
  }
}
