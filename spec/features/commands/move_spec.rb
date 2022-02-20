# frozen_string_literal: true

require "rails_helper"

describe "Sending the move command", type: :feature, js: true do
  let(:character) { create(:character, room: room) }
  let(:room)      { create(:room, x: 0, y: 0, z: 0) }

  before do
    sign_in_as_character character
  end

  it "displays the new room description to the sender" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    send_command(:move, :north)

    expect(page).to have_look_message(north_room)
  end

  it "updates surrounding characters to the sender" do
    north_room      = create(:room, x: 0, y: 1, z: 0)
    north_character = create(:character, room: north_room)

    send_command(:move, :north)

    expect(page).to have_surrounding_character(north_character)
  end

  it "adds new surrounding monsters to the sender" do
    north_room    = create(:room, x: 0, y: 1, z: 0)
    north_monster = create(:monster, room: north_room)

    send_command(:move, :north)

    expect(page).to have_surrounding_monster(north_monster)
  end

  it "removes old surrounding monsters from the sender" do
    north_room    = create(:room, x: 0, y: 1, z: 0)
    north_monster = create(:monster, room: north_room)

    send_command(:move, :north)

    wait_for(have_surrounding_monster(north_monster)) do
      send_command(:move, :south)
    end

    expect(page).not_to have_surrounding_monster(north_monster)
  end

  it "broadcasts the exit message to the source room" do
    create(:room, x: 0, y: 1, z: 0)

    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:move, :north)

    using_session(:nearby_character) do
      expect(page).to have_exit_message(name: character.name, direction: :north)
    end
  end

  it "removes the character from the surroundings in the source room" do
    create(:room, x: 0, y: 1, z: 0)

    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:move, :north)

    using_session(:nearby_character) do
      expect(page).not_to have_surrounding_character(character)
    end
  end

  it "broadcasts the enter message to the target room" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    using_session(:distant_character) do
      sign_in_as_character create(:character, room: north_room)
    end

    send_command(:move, :north)

    using_session(:distant_character) do
      expect(page).to have_enter_message(name: character.name, direction: :north)
    end
  end

  it "adds the character to the surroundings in the target room" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    using_session(:distant_character) do
      sign_in_as_character create(:character, room: north_room)
    end

    send_command(:move, :north)

    using_session(:distant_character) do
      expect(page).to have_surrounding_character(character)
    end
  end

  it "does not broadcast the enter message to the moving character" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    send_command(:move, :north)

    wait_for(have_look_message(north_room)) do
      expect(page).not_to have_enter_message(name: character.name, direction: :north)
    end
  end

  it "does not broadcast the exit message to the moving character" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    send_command(:move, :north)

    wait_for(have_look_message(north_room)) do
      expect(page).not_to have_exit_message(name: character.name, direction: :north)
    end
  end

  it "does not broadcast the exit message to the target room" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    using_session(:distant_character) do
      sign_in_as_character create(:character, room: north_room)
    end

    send_command(:move, :north)

    wait_for(have_look_message(north_room)) do
      using_session(:distant_character) do
        expect(page).not_to have_exit_message(name: character.name, direction: :north)
      end
    end
  end

  it "does not broadcast the enter message to the source room" do
    north_room = create(:room, x: 0, y: 1, z: 0)

    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: room)
    end

    send_command(:move, :north)

    wait_for(have_look_message(north_room)) do
      using_session(:nearby_character) do
        expect(page).not_to have_enter_message(name: character.name, direction: :north)
      end
    end
  end

  context "with no room in the direction" do
    it "displays move failure message to the sender" do
      send_command(:move, :west)

      expect(page).to have_failure_message(direction: :west)
    end

    it "does not broadcast the failure message to the source room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:move, :west)

      wait_for(have_failure_message(direction: :west)) do
        using_session(:nearby_character) do
          expect(page).not_to have_failure_message(direction: :west)
        end
      end
    end
  end

  context "with unknown direction" do
    it "displays unknown direction message to the sender" do
      send_command(:move, :around)

      expect(page).to have_unknown_direction_message
    end

    it "does not broadcast the unknown message to the source room" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: room)
      end

      send_command(:move, :around)

      wait_for(have_unknown_direction_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_unknown_direction_message
        end
      end
    end
  end

  context "with an aliased direction" do
    it "displays the new room description to the sender" do
      north_room = create(:room, x: 0, y: 1, z: 0)

      send_text(:n)

      expect(page).to have_look_message(north_room)
    end
  end

  protected

  def have_enter_message(direction:, **arguments)
    have_css(
      "#messages .message-move-enter",
      text: t("commands.move.enter.#{direction}", **arguments)
    )
  end

  def have_exit_message(direction:, **arguments)
    have_css(
      "#messages .message-move-exit",
      text: t("commands.move.exit.#{direction}", **arguments)
    )
  end

  def have_failure_message(direction:)
    have_css(
      "#messages .message-move-failure",
      text: t("commands.move.failure.message", direction: direction)
    )
  end

  def have_unknown_direction_message
    have_css(
      "#messages .message-move-unknown",
      text: t("commands.move.unknown.message")
    )
  end

  def wait_for(expectation)
    expect(page).to expectation

    yield
  end
end
