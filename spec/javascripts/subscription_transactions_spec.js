describe("SubscriptionTransactions", function() {
  beforeEach(function () {
    loadFixtures("subscription_transactions_index.html")
    window.subscription_transactions.init();
  });

  it("hooks up the new transactions button to the new transaction window", function() {

    expect($("#new_transaction")).toBeHidden();

    $("#show_new_transaction_btn").click();
    expect($("#new_transaction")).toBeVisible();

  });
});