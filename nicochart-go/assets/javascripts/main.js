//= require javascripts/vendor/bootstrap.min
//= require javascripts/plugins

$(function() {
  return $('.img-thumbnail').each(function() {
    return LoadImage(this);
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
