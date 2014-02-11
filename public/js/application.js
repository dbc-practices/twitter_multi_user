$(document).ready(function() {
  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
    $("form").submit(function(e) {
    e.preventDefault();
    console.log("i'm in here")
    $("form :input[type='text']").prop('disabled', true);
    $("#msg").html("Please wait. Your tweet is being processed!");
    var text = $("form :input[name='tweet']").val();

    $.ajax({
      url: "/tweet_it",
      type: "POST",
      data: {tweet: text},
      dataType: "html",
      success: function(result){
        console.log(result);
        $("form :input[type='text']").prop('disabled', false);
        $("#msg").html(result);
      }
    });
  });
});
