# frozen_string_literal: true

require "rails_helper"

describe Commands::Alias, type: :service do
  describe "#call" do
    subject(:call) { instance.call }

    let(:character) { build_stubbed(:character) }
    let(:instance)  { described_class.new("/alias", character: character) }
    let(:result)    { instance_double(described_class::List) }

    before do
      allow(result).to receive(:call)
      allow(described_class::List).to receive(:new)
        .with(character: character)
        .and_return(result)
    end

    it "delegates to list handler" do
      call

      expect(result).to have_received(:call).with(no_args)
    end
  end
end
