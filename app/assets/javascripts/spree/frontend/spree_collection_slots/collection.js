$(document).ready(function(){
  $('.shipping_rate_radio').on('click', function(){
    $('.collection-slots').hide();
    $('.' + $(this).data('target')).show();
  });

  $('.shipping_rate_radio:checked').click();
});
