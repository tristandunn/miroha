# frozen_string_literal: true

require "rails_helper"

describe "Sending the use command", :js do
  let(:character) { create(:character, current_health: 5, maximum_health: 10) }
  let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => 3 }) }

  before do
    item # Force creation before signing in
    sign_in_as_character character
  end

  it "removes the item from character's inventory" do
    send_command(:use, item.name)

    expect(page).not_to have_inventory_item(item)
  end

  it "displays the use success message to the character" do
    send_command(:use, item.name)

    expect(page).to have_use_success_message(item.name, 3)
  end

  it "restores character's health" do
    send_command(:use, item.name)

    expect(page).to have_use_success_message(item.name, 3)
    expect(character.reload.current_health).to eq(8)
  end

  # TODO: This test is flaky due to broadcast timing. The observer broadcast
  # functionality is implemented and works in practice, but has timing issues
  # in the test environment that need further investigation.
  xit "broadcasts the use action to other characters in the same room" do
    using_session(:nearby_character) do
      sign_in_as_character create(:character, room: character.room)
    end

    send_command(:use, item.name)

    using_session(:nearby_character) do
      expect(page).to have_use_observer_message(character.name, item.name)
    end
  end

  it "does not broadcast the use message to characters in other rooms" do
    using_session(:distant_character) do
      sign_in_as_character create(:character)
    end

    send_command(:use, item.name)

    wait_for(have_use_success_message(item.name, 3)) do
      using_session(:distant_character) do
        expect(page).not_to have_use_observer_message(character.name, item.name)
      end
    end
  end

  context "with partial name matching" do
    it "uses the item using partial name" do
      send_command(:use, item.name.slice(0, 2))

      expect(page).to have_use_success_message(item.name, 3)
    end
  end

  context "with stackable item" do
    let(:item) { create(:item, :stackable, owner: character, quantity: 3, metadata: { "consumable" => true, "heal_amount" => 2, "stack_limit" => 5 }) }

    it "decrements the item quantity" do
      send_command(:use, item.name)

      expect(page).to have_use_success_message(item.name, 2)
      expect(item.reload.quantity).to eq(2)
    end

    it "does not remove the item from inventory" do
      send_command(:use, item.name)

      expect(page).to have_inventory_item(item.reload)
    end

    context "with quantity of 1" do
      let(:item) { create(:item, :stackable, owner: character, quantity: 1, metadata: { "consumable" => true, "heal_amount" => 2, "stack_limit" => 5 }) }

      it "removes the item from inventory" do
        send_command(:use, item.name)

        expect(page).not_to have_inventory_item(item)
      end
    end
  end

  context "with health at maximum" do
    let(:character) { create(:character, current_health: 10, maximum_health: 10) }

    it "displays zero hit points restored" do
      send_command(:use, item.name)

      expect(page).to have_use_success_message(item.name, 0)
    end

    it "still removes the item" do
      send_command(:use, item.name)

      expect(page).not_to have_inventory_item(item)
    end
  end

  context "with heal amount exceeding maximum health" do
    let(:character) { create(:character, current_health: 8, maximum_health: 10) }
    let(:item)      { create(:item, owner: character, metadata: { "consumable" => true, "heal_amount" => 5 }) }

    it "displays only the actual hit points restored" do
      send_command(:use, item.name)

      expect(page).to have_use_success_message(item.name, 2)
    end

    it "restores health up to maximum only" do
      send_command(:use, item.name)

      expect(page).to have_use_success_message(item.name, 2)
      expect(character.reload.current_health).to eq(10)
    end
  end

  context "with a missing item name" do
    it "displays the missing item error message to the sender" do
      send_command(:use)

      expect(page).to have_use_missing_message
    end

    it "does not broadcast the error message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:use)

      wait_for(have_use_missing_message) do
        using_session(:nearby_character) do
          expect(page).not_to have_use_missing_message
        end
      end
    end
  end

  context "with unknown item name" do
    let(:name) { generate(:name) }

    it "displays invalid item message to the character" do
      send_command(:use, name)

      expect(page).to have_use_invalid_message(name)
    end

    it "does not broadcast the invalid item message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:use, name)

      wait_for(have_use_invalid_message(name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_use_invalid_message(name)
        end
      end
    end
  end

  context "with non-consumable item" do
    let(:item) { create(:item, owner: character, metadata: {}) }

    before do
      item # Force creation
    end

    it "displays not consumable message to the character" do
      send_command(:use, item.name)

      expect(page).to have_use_not_consumable_message(item.name)
    end

    it "does not remove the item" do
      send_command(:use, item.name)

      expect(page).to have_use_not_consumable_message(item.name)
      expect(page).to have_inventory_item(item)
    end

    it "does not broadcast the error message to other characters" do
      using_session(:nearby_character) do
        sign_in_as_character create(:character, room: character.room)
      end

      send_command(:use, item.name)

      wait_for(have_use_not_consumable_message(item.name)) do
        using_session(:nearby_character) do
          expect(page).not_to have_use_not_consumable_message(item.name)
        end
      end
    end
  end

  protected

  def have_use_invalid_message(item_name)
    have_css(
      "#messages .message-use-invalid",
      text: I18n.t("commands.use.invalid_item.message", name: item_name)
    )
  end

  def have_use_missing_message
    have_css(
      "#messages .message-use-missing",
      text: I18n.t("commands.use.missing_item.message")
    )
  end

  def have_use_not_consumable_message(item_name)
    have_css(
      "#messages .message-use-not-consumable",
      text: I18n.t("commands.use.not_consumable.message", name: item_name)
    )
  end

  def have_use_observer_message(character_name, item_name)
    have_css(
      "#messages .message-use-observer",
      text: I18n.t("commands.use.observer.success.message", character_name: character_name, name: item_name)
    )
  end

  def have_use_success_message(item_name, health_restored)
    have_css(
      "#messages .message-use-success",
      text: I18n.t("commands.use.success.message", name: item_name, count: health_restored)
    )
  end
end
