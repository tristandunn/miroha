# frozen_string_literal: true

require "rails_helper"

describe "Sending the pickup command", :js do
  let(:character) { create(:character, room: item.owner) }
  let(:item)      { create(:item, :room) }

  before do
    sign_in_as_character character
  end

  it "adds the item to the character's inventory" do
    send_command(:pickup, item.name)

    expect(page).to have_inventory_item(item)
  end

  it "displays the pickup success message to the sender" do
    send_command(:pickup, item.name)

    expect(page).to have_pickup_success_message(item.name)
  end

  it "removes the item from room surroundings" do
    send_command(:pickup, item.name)

    expect(page).not_to have_surrounding_item(item)
  end

  it "broadcasts the pickup action to other characters in the same room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:pickup, item.name)

    using_session(:nearby_character) do
      expect(page).to have_pickup_observer_message(character.name, item.name)
    end
  end

  it "removes the item from surroundings for other characters in the same room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:pickup, item.name)

    using_session(:nearby_character) do
      expect(page).to have_no_css("#surrounding_item_#{item.id}")
    end
  end

  it "does not broadcast the pickup message to characters in other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:pickup, item.name)

    wait_for(have_pickup_success_message(item.name)) do
      using_session(:distant_character) do
        expect(page).not_to have_pickup_observer_message(character.name, item.name)
      end
    end
  end

  context "with partial name matching" do
    it "picks up the item using partial name" do
      send_command(:pickup, item.name.slice(0, 2))

      expect(page).to have_pickup_success_message(item.name)
    end
  end

  context "with missing item name" do
    it "displays the missing item error message to the sender" do
      send_command(:pickup)

      expect(page).to have_pickup_missing_message
    end

    it "does not broadcast the error message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:pickup)

      wait_for(have_pickup_missing_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_pickup_missing_message
        end
      end
    end
  end

  context "with unknown item name" do
    let(:name) { generate(:name) }

    it "displays invalid item message to the character" do
      send_command(:pickup, name)

      expect(page).to have_pickup_invalid_message(name)
    end

    it "does not broadcast the invalid item message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:pickup, name)

      wait_for(have_pickup_invalid_message(name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_pickup_invalid_message(name)
        end
      end
    end
  end

  protected

  def have_pickup_invalid_message(name)
    have_css(
      "#messages .message-pickup-invalid",
      text: I18n.t("commands.pickup.invalid_item.message", name: name)
    )
  end

  def have_pickup_missing_message
    have_css(
      "#messages .message-pickup-missing",
      text: I18n.t("commands.pickup.missing_item.message")
    )
  end

  def have_pickup_observer_message(character_name, name)
    have_css(
      "#messages .message-pickup-observer",
      text: I18n.t("commands.pickup.observer.success.message", character_name: character_name, name: name)
    )
  end

  def have_pickup_success_message(name)
    have_css(
      "#messages .message-pickup-success",
      text: I18n.t("commands.pickup.success.message", name: name)
    )
  end
end
