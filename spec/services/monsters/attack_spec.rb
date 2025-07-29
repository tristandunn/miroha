# frozen_string_literal: true

require "rails_helper"

describe Monsters::Attack, type: :service do
  let(:damage)    { 1 }
  let(:instance)  { described_class.new(monster) }
  let(:monster)   { create(:monster) }
  let(:target)    { create(:character, room: monster.room) }

  before do
    allow(SecureRandom).to receive(:random_number).with(0..1).and_return(damage).once
  end

  describe "#call", :cache do
    subject(:call) { instance.call }

    before do
      allow(Turbo::StreamsChannel).to receive(:broadcast_append_later_to)
      allow(Turbo::StreamsChannel).to receive(:broadcast_render_later_to)
      allow(Turbo::StreamsChannel).to receive(:broadcast_replace_later_to)

      EventHandlers::Monster::Hate.on_character_attacked(character: target, damage: 1, monster: monster)
    end

    context "with a valid target" do
      it "damages the target" do
        expect { call }.to change { target.reload.current_health }.by(-damage)
      end

      it "broadcasts attack target hit partial to the target" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            target,
            target:  "messages",
            partial: "monsters/attack/target/hit",
            locals:  {
              attacker_name: monster.name,
              damage:        damage
            }
          )
      end

      it "broadcasts attack hit partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            monster.room,
            target:  "messages",
            partial: "monsters/attack/hit",
            locals:  {
              attacker_name: monster.name,
              character:     target,
              target_name:   target.name
            }
          )
      end

      it "replaces sidebar for the character" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_replace_later_to)
          .with(
            target,
            target:  :character,
            partial: "game/sidebar/character",
            locals:  {
              character: target
            }
          )
      end
    end

    context "with a valid, missed target" do
      let(:damage) { 0 }

      it "does not damage the target" do
        expect { call }.not_to(change { target.reload.current_health })
      end

      it "broadcasts attack target missed partial to the target" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            target,
            target:  "messages",
            partial: "monsters/attack/target/missed",
            locals:  { attacker_name: monster.name }
          )
      end

      it "broadcasts missed partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_append_later_to)
          .with(
            monster.room,
            target:  "messages",
            partial: "monsters/attack/missed",
            locals:  {
              attacker_name: monster.name,
              character:     target,
              target_name:   target.name
            }
          )
      end
    end

    context "with a valid, killed target" do
      before do
        target.update!(current_health: 1)
      end

      it "broadcasts kill partial to the room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            monster.room,
            partial: "monsters/attack/kill",
            locals:  {
              attacker_name: monster.name,
              character:     target,
              target_name:   target.name
            }
          )
      end

      it "resets the character" do
        default_room = create(:room, :default)

        expect { call }.to(
          change { target.reload.current_health }
          .from(1)
          .to(target.maximum_health)
          .and(
            change { target.reload.room }
            .from(monster.room)
            .to(default_room)
          )
        )
      end

      it "broadcasts character reset render to the character" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            target,
            partial: "characters/reset",
            locals:  {
              attacker_name: monster.name,
              character:     target,
              damage:        damage,
              room:          Room.default
            }
          )
      end

      it "broadcasts respawn partial to the respawn room" do
        call

        expect(Turbo::StreamsChannel).to have_received(:broadcast_render_later_to)
          .with(
            Room.default,
            partial: "characters/respawn",
            locals:  { character: target }
          )
      end
    end

    context "with multiple, valid targets" do
      let(:other_target) { create(:character, room: monster.room) }

      before do
        EventHandlers::Monster::Hate.on_character_attacked(
          character: other_target,
          damage:    20,
          monster:   monster
        )
      end

      it "damages the target with the most hate" do
        expect { call }.to change { other_target.reload.current_health }.by(-damage)
      end
    end

    context "with target in a different room" do
      before do
        target.room = create(:room)
        target.save
      end

      it "does not broadcast append" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end

      it "does not broadcast render" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_render_later_to)
      end

      it "does not broadcast replace" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end

    context "with no valid target" do
      before do
        Rails.cache.clear
      end

      it "does not broadcast append" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_append_later_to)
      end

      it "does not broadcast render" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_render_later_to)
      end

      it "does not broadcast replace" do
        call

        expect(Turbo::StreamsChannel).not_to have_received(:broadcast_replace_later_to)
      end
    end
  end
end
