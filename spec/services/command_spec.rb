# frozen_string_literal: true

require "rails_helper"

describe Command, type: :service do
  describe ".call" do
    context "with valid command" do
      let(:character) { build_stubbed(:character) }
      let(:command)   { instance_double(Commands::SayCommand, call: true) }
      let(:input)     { "/say Hello!" }

      before do
        allow(Commands::SayCommand).to receive(:new).and_return(command)
      end

      it "creates the command" do
        described_class.call(input, character: character)

        expect(Commands::SayCommand).to have_received(:new)
          .with(input, character: character)
      end

      it "calls the command" do
        described_class.call(input, character: character)

        expect(command).to have_received(:call).with(no_args)
      end

      it "returns the command" do
        result = described_class.call(input, character: character)

        expect(result).to eq(command)
      end

      context "with whitespace" do
        let(:command) { instance_double(Commands::SayCommand, call: true) }
        let(:input)   { "  /say  something  " }

        it "calls the command with whitespace stripped" do
          allow(Commands::SayCommand).to receive(:new).and_return(command)

          described_class.call(input, character: character)

          expect(Commands::SayCommand).to have_received(:new)
            .with("/say something", character: character)
        end
      end
    end

    context "with no command" do
      let(:character) { build_stubbed(:character) }
      let(:command)   { instance_double(Commands::SayCommand, call: true) }
      let(:input)     { "Hello, world!" }

      before do
        allow(Commands::SayCommand).to receive(:new).and_return(command)
      end

      it "creates the say command" do
        described_class.call(input, character: character)

        expect(Commands::SayCommand).to have_received(:new)
          .with(input, character: character)
      end

      it "calls the command" do
        described_class.call(input, character: character)

        expect(command).to have_received(:call).with(no_args)
      end

      it "returns the command" do
        result = described_class.call(input, character: character)

        expect(result).to eq(command)
      end
    end

    context "with unknown command" do
      let(:character) { build_stubbed(:character) }
      let(:command)   { instance_double(Commands::UnknownCommand, call: true) }
      let(:input)     { "/notareal command" }

      before do
        allow(Commands::UnknownCommand).to receive(:new).and_return(command)
      end

      it "creates the unknown command" do
        described_class.call(input, character: character)

        expect(Commands::UnknownCommand).to have_received(:new)
          .with(input, character: character)
      end

      it "calls the command" do
        described_class.call(input, character: character)

        expect(command).to have_received(:call).with(no_args)
      end

      it "returns the command" do
        result = described_class.call(input, character: character)

        expect(result).to eq(command)
      end
    end
  end
end
