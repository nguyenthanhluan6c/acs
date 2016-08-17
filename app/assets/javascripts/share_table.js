function resetOrder() {
  var stt = 0;
  var list_record = $('table').find('tbody tr .stt:visible');
  $.each(list_record, function(){
    stt++;
    $(this).html(stt);
  });
}
