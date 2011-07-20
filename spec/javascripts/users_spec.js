describe("Users", function() {
  beforeEach(function () {
    loadFixtures("users_home.html")
    window.users.init();
  });

  it("hooks up the manage reminders button to the locations checklist window", function() {

    expect($("#reminder_manager")).toBeHidden();

    $("#manage_reminders").click();
    expect($("#reminder_manager")).toBeVisible();

  });
});