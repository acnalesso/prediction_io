Before do
  @user = PredictionIO::User
  user = { user: { user_id: 1 }}.to_json

  # check out active_resource/http_mock for more info
  ActiveResource::HttpMock.respond_to do |m|
    m.get("/users.json", Accept,
      { users: [] }.to_json, 200, ResponseHeaders)

    m.get("/users/1.json", Accept, user, 200, ResponseHeaders)

    m.post("/users.json",
      { "Authorization" => "Basic YmF0bWFuOnNlY3JldA==" },
      user, 201, ResponseHeaders)
  end

end

Given(/^no user exists yet$/) do
  @user.all.should have(0).users
end

When(/^I create a user with id "(.*?)"$/) do |user_id|
  @user.create_user(user_id.to_i)
end

Then(/^there should exist one user$/) do
  @user.find(1).should be_kind_of PredictionIO::User
end
