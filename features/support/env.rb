$:.unshift File.expand_path('../../../lib', __FILE__)

require 'active_resource'
require 'prediction_io'


module PredictionIO
  Logger = Object.new
  def Logger.error(n); n; end
end

##
# Whenever you ask a job if it is +done+
# it returns false if not, here we wait
# until a job is done and then yields its
# result.
#
def wait_for(job, method=:done)
  until job.done
    sleep(0.001) unless job.done
  end
  yield(job.send(method))
end


Before do
  @user = PredictionIO::User
  user = { pio_uid: 1, pio_appkey: "abc" }.to_json

  # check out active_resource/http_mock for more info
  ActiveResource::HttpMock.respond_to do |m|
    m.get("/users.json", Accept,
      { users: [] }.to_json, 200, ResponseHeaders)

    m.get("/users/1.json", Accept, user, 200, ResponseHeaders)
    m.get("/users/1.json?pio_uid=1", Accept, user, 200, ResponseHeaders)
    m.get("/users/1.json?pio_appkey=abc&pio_uid=1", Accept, user, 200, ResponseHeaders)

    m.post("/users.json",
      { "Authorization" => "Basic YmF0bWFuOnNlY3JldA==" },
      user, 201, ResponseHeaders)

    m.get("/users/3.json?pio_uid=3", Accept, {}.to_json, 404, ResponseHeaders)
    m.delete("/users/3.json?pio_uid=3", Accept, user, 202, ResponseHeaders)
  end

end
