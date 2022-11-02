# frozen_string_literal: true

require "rails_helper"

describe CharacterSelectForm, type: :form do
  subject(:form) { described_class.new(account: account, id: id) }

  describe "#initialize" do
    let(:account) { build_stubbed(:account) }
    let(:id)      { SecureRandom.random_number }

    it "assigns the account" do
      expect(form.account).to eq(account)
    end

    it "assigns the ID" do
      expect(form.id).to eq(id)
    end
  end

  describe "#character" do
    let(:account) { create(:account) }

    context "with a matching character" do
      let(:character) { create(:character, account: account) }
      let(:id)        { character.id }

      it "returns the character" do
        expect(form.character).to eq(character)
      end
    end

    context "with an unknown account" do
      let(:id) { SecureRandom.random_number }

      it "returns nil" do
        expect(form.character).to be_nil
      end
    end

    context "with a blank ID" do
      let(:id) { "" }

      before do
        allow(account).to receive(:characters)
      end

      it "does not attempt to find the character" do
        form.character

        expect(account).not_to have_received(:characters)
      end

      it "returns nil" do
        expect(form.character).to be_nil
      end
    end
  end

  describe "#ensure_character_is_valid", :cache do
    let(:account) { create(:account) }

    context "with a valid ID" do
      let(:character) { create(:character, account: account) }
      let(:id)        { character.id }

      it "is valid" do
        expect(form).to be_valid
      end

      it "marks the character as recently selected", :freeze_time do
        allow(Rails.cache).to receive(:write)

        form.valid?

        expect(Rails.cache).to have_received(:write).with(
          Character::SELECTED_KEY % id,
          described_class::LIMIT_DURATION.from_now,
          expires_in: described_class::LIMIT_DURATION
        )
      end

      it "does not add errors" do
        form.valid?

        expect(form.errors).to be_empty
      end
    end

    context "without a character" do
      let(:id) { SecureRandom.random_number }

      it "is not valid" do
        expect(form).not_to be_valid
      end

      it "adds an error message for base" do
        form.valid?

        expect(form.errors[:base]).to eq(
          [t("activemodel.errors.models.character_select_form.attributes.base.character_missing")]
        )
      end
    end

    context "with a recently selected character" do
      let(:character) { create(:character, account: account) }
      let(:id)        { character.id }

      before do
        Rails.cache.write(Character::SELECTED_KEY % id, 5.minutes.from_now, expires_in: 5.minutes)
      end

      it "is not valid" do
        expect(form).not_to be_valid
      end

      it "adds an error message for base" do
        form.valid?

        expect(form.errors[:base]).to eq(
          [t("activemodel.errors.models.character_select_form.attributes.base.character_recent")]
        )
      end
    end
  end
end
