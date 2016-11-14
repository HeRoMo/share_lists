// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
  $("#like").on('ajax:success', function(event, data, status, xhr){
    $(event.target).addClass('yes');
    $('#unlike').addClass('yes')
  })
  $('#unlike').on('ajax:success', function(event, data, status, xhr){
    $(event.target).removeClass('yes');
    $('#like').removeClass('yes')
  })
});


