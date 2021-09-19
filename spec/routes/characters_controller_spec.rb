# frozen_string_literal: true

require "rails_helper"

describe CharactersController, type: :routing do
  it { is_expected.to route(:get, "/characters").to(action: :index) }
  it { is_expected.to route(:get, "/characters/new").to(action: :new) }
  it { is_expected.to route(:post, "/characters").to(action: :create) }
end
