# frozen_string_literal: true

class FakeMailDelivery
  def deliver_now
    :delivered
  end

  def deliver_later
    :queued
  end
end

RSpec.describe TransactionGuard::Detectors::Mail do
  let(:delivery_class) do
    Class.new(FakeMailDelivery).tap do |klass|
      klass.prepend(TransactionGuard::Detectors::Mail)
    end
  end

  it "reports deliver_now inside a transaction" do
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Email delivery")

    User.transaction do
      expect(delivery_class.new.deliver_now).to eq(:delivered)
    end
  end

  it "reports deliver_later inside a transaction" do
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Email delivery")

    User.transaction do
      expect(delivery_class.new.deliver_later).to eq(:queued)
    end
  end
end

RSpec.describe "TransactionGuard ActionMailer integration" do
  it "prepends the mail detector" do
    expect(ActionMailer::MessageDelivery.ancestors)
      .to include(TransactionGuard::Detectors::Mail)
  end
end

RSpec.describe TransactionGuard::Detectors::Mail do
  describe "outside a transaction" do
    it "does not report" do
      delivery = Class.new(FakeMailDelivery) do
        prepend TransactionGuard::Detectors::Mail
      end

      expect(TransactionGuard::Reporter).not_to receive(:report)

      delivery.new.deliver_now
    end
  end
end

RSpec.describe "Mail and ActiveJob integration" do
  it "reports deliver_later only once" do
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Email delivery")
      .once

    User.transaction do
      TestMailer.welcome.deliver_later
    end
  end
end

RSpec.describe "Mail detector raise mode" do
  let(:delivery_class) do
    Class.new(FakeMailDelivery).tap do |klass|
      klass.prepend(TransactionGuard::Detectors::Mail)
    end
  end

  it "raises inside a transaction" do
    TransactionGuard.configure { |config| config.mode = :raise }

    expect do
      User.transaction do
        delivery_class.new.deliver_now
      end
    end.to raise_error(TransactionGuard::Error)
  end
end

RSpec.describe "Mail detector off mode" do
  let(:delivery_class) do
    Class.new(FakeMailDelivery).tap do |klass|
      klass.prepend(TransactionGuard::Detectors::Mail)
    end
  end

  it "does not report inside a transaction" do
    TransactionGuard.configure { |config| config.mode = :off }

    expect(TransactionGuard::Reporter).not_to receive(:report)

    User.transaction do
      delivery_class.new.deliver_now
    end
  end
end
