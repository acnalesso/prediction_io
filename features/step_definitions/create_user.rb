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

When(/^I create an user with id "(.*?)"$/) do |user_id|
  @worker = @user.acreate(user_id.to_i) { |r| r }
end

Then(/^there should exist one user$/) do
  wait_for(@worker) { |user| user.should_not be_a_new_record }
end

Given(/^no users exist$/) do
  @user.all.should have(0).users
end

When(/^I create a new user with id "(.*?)", pio_latitude: "(.*?)", and pio_longitude: "(.*?)"$/) do |user_id, lat, lon|
  params = { pio_latitude: lat, pio_longitude: lon }
  @worker = @user.acreate(user_id.to_i, params) { |r| r }
end

Then(/^I should have one user created$/) do
  wait_for(@worker) { |user| user.should_not be_a_new_record }
end
