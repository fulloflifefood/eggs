/*
  javascript for subscription_transactions controller actions
 */

var subscription_transactions = {
  init: function(){
    $(".increment_transaction").css( 'cursor', 'pointer' ).click(function(){
      var field = $(this).closest('tr').find(".amount");
      var oldValue = field.val() || 0;
      field.val(parseFloat(field.val() || 0) + 1)

    });

    $("#datepicker").datepicker();

    $(".positive_int").numeric({ negative : false, decimal : false });

  }

};
