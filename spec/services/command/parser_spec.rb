# frozen_string_literal: true

require "rails_helper"

describe Command::Parser, type: :service do
  describe ".call" do
    subject { described_class.call(input) }

    let(:command) { Class.new(Commands::Base) }

    context "with a command without arguments" do
      let(:input) { "/Help" }

      before do
        stub_const("Commands::Help", command)
      end

      it { is_expected.to eq(command) }

      context "with an internationalized command" do
        let(:input) { "/cabhrú" }

        before do
          allow(I18n).to receive(:t).with("commands.lookup").and_return(help: { name: "cabhrú" })
        end

        it { is_expected.to eq(command) }
      end
    end

    context "with a command with arguments" do
      let(:input) { "/say Hello, world." }

      before do
        stub_const("Commands::Say", command)
      end

      it { is_expected.to eq(command) }
    end

    context "with a command with and without arguments" do
      let(:argument_command) do
        Class.new(Commands::Base) do
          def self.match?(arguments)
            arguments.first == "add"
          end
        end
      end

      let(:no_argument_command) do
        Class.new(Commands::Base) do
          def self.match?(arguments)
            arguments.empty?
          end
        end
      end

      before do
        stub_const("Commands::Nested::Add", argument_command)
        stub_const("Commands::Nested::List", no_argument_command)

        allow(I18n).to receive(:t).with("commands.lookup").and_return(nested: { name: "nested" })
      end

      context "when provided arguments" do
        let(:input) { "/nested add example" }

        it { is_expected.to eq(argument_command) }
      end

      context "when not provided arguments" do
        let(:input) { "/nested" }

        it { is_expected.to eq(no_argument_command) }
      end

      context "when provided invalid arguments" do
        let(:input) { "/nested invalid" }

        before do
          stub_const("Commands::Unknown", command)
        end

        it { is_expected.to eq(command) }
      end

      context "when provided a class that is not a command" do
        let(:input) { "/nested hidden" }

        before do
          stub_const("Commands::Nested::Hidden", Module.new)
          stub_const("Commands::Unknown", command)
        end

        it { is_expected.to eq(command) }
      end
    end

    context "with no command" do
      let(:input) { "Hello, world!" }

      before do
        stub_const("Commands::Say", command)
      end

      it { is_expected.to eq(command) }
    end

    context "with invalid command" do
      let(:input) { "/notacommand" }

      before do
        stub_const("Commands::Unknown", command)
      end

      it { is_expected.to eq(command) }
    end
  end
end
