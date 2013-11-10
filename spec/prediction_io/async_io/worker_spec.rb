require 'spec_helper'

describe PredictionIO::AsyncIO::Worker do

  let(:payload)   { ->(r) { r } }
  let(:job_block) { :iam_a_dog }
  let(:job)       { -> { job_block } }

  subject { described_class.new(payload, job) }

  it { should respond_to(:done) }

  context "initialise" do
    its(:payload) { should be_kind_of(Proc) }
    its(:job)     { should be_kind_of(Proc) }
  end

  its(:done) { should be_false }
  its(:call) { should eq(job_block) }

  context "Getting a job done" do
    before { subject.call }

    its(:done) { should eq(job_block)}
  end
end
