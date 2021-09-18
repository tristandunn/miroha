# frozen_string_literal: true

require "rails_helper"

describe CharactersController, type: :routing do
  it { is_expected.to route(:get, "/characters").to(action: :index) }
end
