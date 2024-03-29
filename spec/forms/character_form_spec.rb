# frozen_string_literal: true

require "rails_helper"

describe CharacterForm, type: :form do
  describe "class" do
    it "inherits from the base form" do
      expect(described_class.superclass).to eq(BaseForm)
    end
  end

  describe "#character" do
    subject(:form) do
      described_class.new(account: account, name: generate(:name))
    end

    let(:account) { create(:account) }
    let(:room)    { create(:room) }

    before do
      allow(Room).to receive(:default).and_return(room)
    end

    it "builds a new character with the form attributes" do
      expect(form.character).to be_a(Character).and(be_new_record).and(
        have_attributes(
          name:    form.name,
          playing: true,
          room:    room
        )
      )
    end
  end

  describe "#save" do
    subject(:form) do
      described_class.new(account: account, name: generate(:name))
    end

    let(:account) { create(:account) }
    let(:room)    { create(:room) }

    before do
      allow(Room).to receive(:default).and_return(room)
    end

    context "when valid" do
      it "saves the character" do
        form.save

        expect(form.character).to be_persisted
      end
    end

    context "when invalid" do
      before do
        create(:character, name: form.name)
      end

      it "does not save the character" do
        form.save

        expect(form.character).not_to be_persisted
      end

      it "merges character errors" do
        form.save

        expect(form.errors.messages[:name]).to eq([t("errors.messages.taken")])
      end
    end
  end
end
