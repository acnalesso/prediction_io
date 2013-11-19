Given(/^I have one user created$/) do
 @user.acreate(1)
end

When(/^I get user with id "(.*?)"$/) do |uid|
  params = { pio_appkey: "abc" }
  @worker = @user.aget(1, params)
end

Then(/^I should have this user$/) do
  wait_for(@worker) { |user|
    user["pio_uid"].should eq(1)
    user["pio_appkey"].should eq("abc")
  }
end

