# frozen_string_literal: true

require "rails_helper"

describe Commands::Help, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:instance)  { described_class.new("/help", character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    it "does not broadcast" do
      call

      expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
    end

    it "returns nil" do
      expect(call).to be_nil
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    it { is_expected.to be(true) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    let(:command)      { { arguments: "[test]", description: "Testing.", name: "example" } }
    let(:translations) { { example: { arguments: "[test]", description: "Testing." } } }

    before do
      allow(I18n).to receive(:t).with("commands.help.commands").and_return(translations)

      described_class.instance_variable_set(:@commands, nil)
    end

    after do
      described_class.instance_variable_set(:@commands, nil)
    end

    it "returns the partial with command locals" do
      expect(render_options).to eq(
        partial: "commands/help",
        locals:  {
          commands: [command]
        }
      )
    end
  end
end
