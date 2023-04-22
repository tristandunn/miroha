# frozen_string_literal: true

require "rails_helper"

describe Commands::EmoteCommand, type: :service do
  let(:character) { build_stubbed(:character) }
  let(:command)   { "/emote #{message}" }
  let(:instance)  { described_class.new(command, character: character) }

  describe "#call" do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
    end

    context "with no punctuation" do
      let(:message) { "laughs" }

      it "broadcasts emote partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            character.room_gid,
            target:  "messages",
            partial: "commands/emote",
            locals:  {
              message: "#{character.name} #{message}#{described_class::DEFAULT_PUNCTUATION}"
            }
          )
      end
    end

    described_class::PUNCTUATION_CHARACTERS.each do |punctuation|
      context "with #{punctuation} punctuation" do
        let(:message) { "laughs#{punctuation}" }

        it "does not append default punctuation" do
          call

          expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
            .with(
              character.room_gid,
              target:  "messages",
              partial: "commands/emote",
              locals:  {
                message: "#{character.name} #{message}"
              }
            )
        end
      end
    end

    context "with blank message" do
      let(:command) { "/emote " }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end

    context "with no message" do
      let(:command) { "/emote" }

      it "does not broadcast" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end
    end
  end

  describe "#rendered?" do
    subject(:rendered?) { instance.rendered? }

    let(:message) { "laughs" }

    it { is_expected.to be(false) }
  end

  describe "#render_options" do
    subject(:render_options) { instance.render_options }

    let(:message) { "laughs" }

    it "returns the partial with character and message locals" do
      expect(render_options).to eq(
        partial: "commands/emote",
        locals:  {
          message: "#{character.name} #{message}#{described_class::DEFAULT_PUNCTUATION}"
        }
      )
    end
  end
end
