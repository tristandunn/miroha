# frozen_string_literal: true

require "rails_helper"

describe SessionsController, type: :routing do
  it { is_expected.to route(:get, "/sessions/new").to(action: :new) }
  it { is_expected.to route(:post, "/sessions").to(action: :create) }
end
