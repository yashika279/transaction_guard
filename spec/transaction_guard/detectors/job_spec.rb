# frozen_string_literal: true

class FakeJob
  def self.perform_later(...)
    :queued
  end
end

class TestJob < ActiveJob::Base
  def perform
    :performed
  end
end

RSpec.describe "ActiveJob integration" do
  it "prepends the job detector" do
    expect(ActiveJob::Base.singleton_class.ancestors)
      .to include(TransactionGuard::Detectors::Job)
  end
end

RSpec.describe "ActiveJob detection" do
  it "reports perform_later inside a transaction" do
    ActiveJob::Base.queue_adapter = :test

    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Job enqueue")

    User.transaction do
      TestJob.perform_later
    end
  end

  it "reports perform_now inside a transaction" do
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Job execution")

    User.transaction do
      TestJob.perform_now
    end
  end

  it "raises in raise mode inside a transaction" do
    TransactionGuard.configure { |config| config.mode = :raise }

    expect do
      User.transaction do
        TestJob.perform_later
      end
    end.to raise_error(TransactionGuard::Error)
  end
end

RSpec.describe TransactionGuard::Detectors::Job do
  let(:job_class) do
    Class.new(FakeJob).tap do |klass|
      klass.singleton_class.prepend(TransactionGuard::Detectors::Job)
    end
  end

  it "reports job enqueue inside a transaction" do
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Job enqueue")

    User.transaction do
      expect(job_class.perform_later).to eq(:queued)
    end
  end
end
