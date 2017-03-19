//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require cocoon
//= require adminlte
//= require turbolinks
//= require cable
//= require jquery.noty.js
//= require jquery-ui/effects/effect-highlight



var notify = function(message, type){
  var n = noty({
    text: message,
    layout: "topRight",
    type: type,
    theme: "relax",
    timeout: 5000
  });
}
