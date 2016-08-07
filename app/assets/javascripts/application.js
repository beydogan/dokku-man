//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require cocoon
//= require adminlte
//= require turbolinks
//= require cable
//= require jquery.noty.js



var notify = function(message, type){
  var n = noty({
    text: message,
    layout: "topRight",
    type: type,
    theme: "relax",
    timeout: 5000
  });
}
