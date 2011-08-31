describe("SubscriptionTransactions", function() {

  describe("#index", function(){
    beforeEach(function () {
      loadFixtures("subscription_transactions_index.html");
      window.subscription_transactions.init();
    });

    it("hooks up the new transactions button to the new transaction window", function() {

      expect($("#new_transaction")).toBeHidden();

      $("#show_new_transaction_btn").click();
      expect($("#new_transaction")).toBeVisible();

    });

    it("adds the initial list with data attributes", function(){
      var transactions = $('#subscription_transactions_list').data('subscription-transactions');
      expect(transactions.length).toEqual(2);
      expect(transactions[0].subscription_transaction.amount).toEqual(3);
    });
  });

});