# frozen_string_literal: true

require "rails_helper"

describe Commands::Help::Success, type: :service do
  describe "class" do
    it { is_expected.to delegate_method(:commands).to(:class) }

    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe ".commands" do
    subject(:commands) { described_class.commands }

    let(:translations) do
      { attack: { arguments: "[target]", description: "Attempt to attack a target." } }
    end

    before do
      allow(I18n).to receive(:t)
        .with("commands.help.commands")
        .and_return(translations)

      described_class.instance_variable_set(:@commands, nil)
    end

    it "returns translation details with command name" do
      expect(commands).to contain_exactly(
        {
          arguments:   "[target]",
          description: "Attempt to attack a target.",
          name:        "attack"
        }
      )
    end
  end

  describe "#locals" do
    subject { instance.locals }

    let(:commands) { double }
    let(:instance) { described_class.new }

    before do
      allow(instance).to receive(:commands).and_return(commands)
    end

    it { is_expected.to eq(commands: commands) }
  end
end
