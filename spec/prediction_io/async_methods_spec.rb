require 'spec_helper'
require 'prediction_io/async_methods'

class FakeUser
  extend PredictionIO::AsyncMethods

  def self.merge_params(id, params)
    { pio_uid: id }.merge!(params)
  end

end

describe PredictionIO::AsyncMethods do

  let(:user) { FakeUser }

  before do
      user.stub(:pio).
        and_return(PredictionIO::FakeAsync)
  end

  context ".acreate" do
    let(:params) { { pio_uid: 1 } }
    before { user.stub(:create).with(params).and_return(true) }

    it "should create an user" do
      user.acreate(1).should be_true
    end

    it "should take extra params" do
      extra = { pio_latitude: 0.0, pio_longitude: 0.2 }
      params.merge!(extra)

      user.acreate(1, extra).should be_true
    end

    it "should return result" do
      user.acreate(1) { |u|
        user.should be_true
      }
    end

  end


  let(:get_params) { { pio_uid: 1, pio_appkey: "key" } }
  context ".aget" do
    before { user.stub(:get).with(1, get_params).and_return(true) }

    it { user.should respond_to :aget }

    it "should get one user" do
      user.aget(1, get_params).should be_true
    end

    ##
    # NOTE: On the before block above,
    # we stubbed User.get to return +true+,
    # that is why we assert that the result
    # within block should be true
    #
    it "should have result result" do
      user.aget(1, get_params) { |u|
        u.should be_true
      }
    end

  end

  context ".adelete" do
    before do
      user.stub(:delete).
        with(1, get_params).
        and_return(:deleted)
    end

    it { user.should respond_to :adelete }

    it "should delete an user" do
      user.adelete(1, get_params).should be_deleted
    end

    it "should return deleted user" do
      user.adelete(1, get_params) { |u|
        u.should be_deleted
      }
    end
  end
end
