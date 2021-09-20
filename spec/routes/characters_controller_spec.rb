# frozen_string_literal: true

require "rails_helper"

describe CharactersController, type: :routing do
  it { is_expected.to route(:get, "/characters").to(action: :index) }
  it { is_expected.to route(:get, "/characters/new").to(action: :new) }
  it { is_expected.to route(:post, "/characters").to(action: :create) }
  it { is_expected.to route(:post, "/characters/1/select").to(action: :select, id: 1) }
end
