$:.unshift File.expand_path('../../../lib', __FILE__)

require 'active_resource'
require 'prediction_io'


##
# Whenever you ask a job if it is +done+
# it returns false if not, here we wait
# until a job is done and then yields its
# result.
#
def wait_for(job, method=:finished)
  until result = job.send(method)
    break if job.finished
    sleep(0.001)
  end
  yield(job.done)
end


Before do
  @user = PredictionIO::User
  user = { pio_uid: 1, pio_appkey: "abc" }.to_json

  # check out active_resource/http_mock for more info
  ActiveResource::HttpMock.respond_to do |m|

    m.get("/users.json",              Accept, { users: [] }.to_json,  200, ResponseHeaders)
    m.get("/users/1.json",            Accept, user,                   200, ResponseHeaders)
    m.get("/users/1.json?pio_uid=1",  Accept, user,                   200, ResponseHeaders)
    m.get("/users/3.json?pio_appkey=my_app_key&pio_uid=3",  Accept, {}.to_json,             404, ResponseHeaders)
    m.get("/users/1.json?pio_appkey=abc&pio_uid=1", Accept, user,     200, ResponseHeaders)

    # Uncomment when testing against auth.
    # m.post("/users.json",
    #  { "Authorization" => "Basic YmF0bWFuOnNlY3JldA==" },
    #  user, 201, ResponseHeaders)

    m.post("/users.json", { "Content-Type" => "application/json" }, user, 201, ResponseHeaders)

    m.delete("/users/3.json?pio_appkey=my_app_key&pio_uid=3", Accept, user, 202, ResponseHeaders)
  end

end
