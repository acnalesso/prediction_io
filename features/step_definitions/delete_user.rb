Given(/^I have an user created$/) do
  @user.acreate(3)
end

When(/^I delete user with id "(.*?)"$/) do |uid|
  @user.adelete(uid.to_i)
end

Then(/^I should not have user with id 3$/) do
  wait_for(@user.aget(3) { |r| @r = r }) { |r|
   @r.notice.response.code.should eq(404)
  }
end

