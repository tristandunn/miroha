# frozen_string_literal: true

require "rails_helper"

describe Commands::Help::Command, type: :service do
  describe "class" do
    it "inherits from command result" do
      expect(described_class.superclass).to eq(Commands::Result)
    end
  end

  describe "#locals" do
    subject(:locals) { instance.locals }

    let(:instance) { described_class.new(name: name) }

    context "with a command without subcommands" do
      let(:name) { "help" }

      it "returns the command details" do
        expect(locals).to eq(
          commands: [
            {
              arguments:   t("commands.help.commands.help.arguments"),
              description: t("commands.help.commands.help.description"),
              name:        name
            }
          ]
        )
      end
    end

    context "with a command with subcommands" do
      let(:name) { "alias" }

      it "returns the command details" do # rubocop:disable RSpec/ExampleLength
        expect(locals).to eq(
          commands: [
            {
              arguments:   "add [alias] [command]",
              description: t("commands.help.commands.alias.subcommands.add.description"),
              name:        "alias"
            },
            {
              arguments:   "list",
              description: t("commands.help.commands.alias.subcommands.list.description"),
              name:        "alias"
            },
            {
              arguments:   "remove [alias]",
              description: t("commands.help.commands.alias.subcommands.remove.description"),
              name:        "alias"
            },
            {
              arguments:   "show [alias]",
              description: t("commands.help.commands.alias.subcommands.show.description"),
              name:        "alias"
            }
          ]
        )
      end
    end
  end

  describe "#partial" do
    subject { instance.render_options[:partial] }

    let(:instance) { described_class.new(name: "help") }

    it { is_expected.to eq("commands/help/list") }
  end
end
