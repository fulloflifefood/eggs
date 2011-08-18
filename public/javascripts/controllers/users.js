/*
  javascript for users_controller actions
 */

var users = {
  init: function(){
    $("#manage_reminders").css( 'cursor', 'pointer' ).click(function(){
      $("#reminder_manager").slideToggle(300, function(){
        $("#form_output").html("");
        if ($(this).is(":visible")) {
          $("#reminder_submit_btn, #reminder_cancel_btn").show();
        }
      });
    });

    $("#reminder_cancel_btn").click(function(){
      $("#reminder_manager").hide();
    });
    $("#reminder_submit_btn").click(function(){
      var form = $("#reminder_manager form")
      var output = $("#form_output")

      $("#reminder_cancel_btn, #reminder_submit_btn").hide();
      output.html("Updating...")



      $.ajax({
          type: "POST",
          url: form.attr("action"),
          data: form.serialize(),
          error: function() {
              output.html('Oops... error.');
          },
          success: function(data) {
            if(data === "success") {
              output.html("Save successful")
              $('#reminder_manager').delay(1200).slideUp(300);
            }else{
              output.html("Oops... didn't save.")
            }
          }
       });


    })
  }

};
