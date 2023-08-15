# frozen_string_literal: true

require "rails_helper"

describe Commands::Help, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("/help", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    let(:result) { instance_double(described_class::Success) }

    before do
      allow(result).to receive(:call)
      allow(described_class::Success).to receive(:new)
        .with(no_args)
        .and_return(result)
    end

    it "delegates to success handler" do
      call

      expect(result).to have_received(:call).with(no_args)
    end
  end
end
