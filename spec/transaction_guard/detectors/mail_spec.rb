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
    Class.new(FakeMailDelivery) do
      prepend TransactionGuard::Detectors::Mail
    end
  end

  it "reports deliver_now inside a transaction" do
    expect_report

    User.transaction do
      expect(delivery_class.new.deliver_now).to eq(:delivered)
    end
  end

  it "reports deliver_later inside a transaction" do
    expect_report

    User.transaction do
      expect(delivery_class.new.deliver_later).to eq(:queued)
    end
  end

  def expect_report
    expect(TransactionGuard::Reporter)
      .to receive(:report)
      .with(operation: "Email delivery")
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
