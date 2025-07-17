# frozen_string_literal: true

require "rails_helper"

describe "Sending the drop command", :js do
  let(:character) { create(:character) }
  let(:item)      { create(:item, owner: character) }

  before do
    sign_in_as_character character
  end

  it "removes the item from character's inventory" do
    send_command(:drop, item.name)

    expect(page).not_to have_inventory_item(item)
  end

  it "displays the drop success message to the character" do
    send_command(:drop, item.name)

    expect(page).to have_drop_success_message(item.name)
  end

  it "adds the item to the room surroundings" do
    send_command(:drop, item.name)

    expect(page).to have_surrounding_item(item)
  end

  it "broadcasts the drop action to other characters in the same room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:drop, item.name)

    using_session(:nearby_character) do
      expect(page).to have_drop_observer_message(character.name, item.name)
    end
  end

  it "adds the item to the surroundings for other characters in the same room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:drop, item.name)

    using_session(:nearby_character) do
      expect(page).to have_surrounding_item(item)
    end
  end

  it "does not broadcast the drop message to characters in other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:drop, item.name)

    wait_for(have_drop_success_message(item.name)) do
      using_session(:distant_character) do
        expect(page).not_to have_drop_observer_message(character.name, item.name)
      end
    end
  end

  context "with partial name matching" do
    it "drop the item using partial name" do
      send_command(:drop, item.name.slice(0, 2))

      expect(page).to have_drop_success_message(item.name)
    end
  end

  context "with a missing item name" do
    it "displays the missing item error message to the sender" do
      send_command(:drop)

      expect(page).to have_drop_missing_message
    end

    it "does not broadcast the error message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:drop)

      wait_for(have_drop_missing_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_drop_missing_message
        end
      end
    end
  end

  context "with unknown item name" do
    let(:name) { generate(:name) }

    it "displays invalid item message to the character" do
      send_command(:drop, name)

      expect(page).to have_drop_invalid_message(name)
    end

    it "does not broadcast the invalid item message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:drop, name)

      wait_for(have_drop_invalid_message(name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_drop_invalid_message(name)
        end
      end
    end
  end

  protected

  def have_drop_invalid_message(item_name)
    have_css(
      "#messages .message-drop-invalid",
      text: t("commands.drop.invalid_item.message", name: item_name)
    )
  end

  def have_drop_missing_message
    have_css(
      "#messages .message-drop-missing",
      text: t("commands.drop.missing_item.message")
    )
  end

  def have_drop_observer_message(character_name, item_name)
    have_css(
      "#messages .message-drop-observer",
      text: t("commands.drop.observer.success.message", character_name: character_name, name: item_name)
    )
  end

  def have_drop_success_message(item_name)
    have_css(
      "#messages .message-drop-success",
      text: t("commands.drop.success.message", name: item_name)
    )
  end
end
