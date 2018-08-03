$(document).on('ready', function(){
  $('#submit_comment').on('click', function(e){
    e.preventDefault();
    var idBook = $('#comment_book_id').val();
    var rateScore = $('#rating_book').raty('score');
    var contentComment = $('#comment_content').val();
    var authenticityToken = $('#form_comment input[name=authenticity_token]').val();
    $.ajax({
      url: '/comments',
      type: 'POST',
      cache: false,
      dataType: 'script',
      data: {
        authenticity_token: authenticityToken,
        book_id: idBook,
        content: contentComment,
        rate: rateScore
      },
    });
  });
})
