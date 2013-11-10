Given(/^I have "(\d+)" threads sleeping$/) do |n_threads|
  @worker = PredictionIO::AsyncIO.new(n_threads.to_i)
  @worker.threads.each { |t| t.alive?.should be_true }
end

When(/^(\d+) exceptions happen$/) do |exceptions|
  exceptions.to_i.times { |e|
    @worker.async { raise e }
  }
end

Then(/^all my threads should be still alive$/) do
  @worker.threads.each { |t| t.alive?.should be_true }
end

