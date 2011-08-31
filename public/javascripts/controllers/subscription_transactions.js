/*
  javascript for subscription_transactions controller actions
 */

var subscription_transactions = {
  init: function(){
    var self = this;

    $(".increment_transaction").css( 'cursor', 'pointer' ).click(function(){
      var field = $(this).closest('tr').find(".amount");
      var oldValue = field.val() || 0;
      field.val(parseFloat(field.val() || 0) + 1)

    });

    $("#datepicker").datepicker();

    $(".positive_int").numeric({ negative : false, decimal : false });

    var format_methods = {
        format_timestamp: function(){
          var date = new Date(this.data.subscription_transaction.created_at);
          return $.format.date(date.toString(), "MM/dd/yyyy hh:mm:ss");
        },
        format_date: function(){
          var date = new Date(this.data.subscription_transaction.date);
          return date.toDateString();
        },
        format_amount: function(){
          if (this.data.subscription_transaction.debit == true){
            return "-"+this.data.subscription_transaction.amount;
          }else{
            return "+"+this.data.subscription_transaction.amount;
          }
        },
        format_amount_style: function(){
          if(this.data.subscription_transaction.debit == false){
            return "color:green;font-weight:bold";
          }
        },
        format_order_id: function(){
          return "<a href='foo'>"+this.data.subscription_transaction.order_id+"</a>"
        }
    };

    if ($('#subscription_transactions_list').data('subscription-transactions')){
      $("#subscription_transaction_template").tmpl($("#subscription_transactions_list").data('subscription-transactions'), format_methods)
        .appendTo("#subscription_transactions_list")
    }


    $("#transaction_cancel_btn").click($.proxy(function(){
      console.log("cancel")
      self.resetDialog();
    }));

    $("#show_new_transaction_btn").click(function(){
      $("#new_transaction").show();
      $(this).hide();
    });

    $("#transaction_submit_btn").click(function(){
      var form = $("#new_transaction form");
      var output = $("#form_output");

      $("#transaction_cancel_btn, #transaction_submit_btn").hide();
      output.html("Updating...");

      $.ajax({
          type: "POST",
          url: form.attr("action"),
          data: form.serialize(),
          error: function() {
              output.html('Oops... error.');
          },
          success: function(data) {
            if(data.status == "success") {
              output.html("Save successful");
              $("#subscription_transaction_template").tmpl(data['data'], format_methods)
                .appendTo("#subscription_transactions_list").children().effect("highlight", {}, 3500);
              $("#current_balance").html(data['data']['subscription_transaction']['balance']);
              self.resetDialog();
            }else{
              output.html("Error saving:<br/>" + data['errors'])
              $("#transaction_cancel_btn, #transaction_submit_btn").show();              
            }
          }
       });


    })
  },

  resetDialog: function(){
    $("#new_transaction").hide();
    $("#show_new_transaction_btn").show();
    var form = $("#new_transaction form");
    $(":text", form).val('');
    $("a.button", form).show();
    $("#form_output").html("");
  }

};
