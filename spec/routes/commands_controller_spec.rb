# frozen_string_literal: true

require "rails_helper"

describe CommandsController, type: :routing do
  it { is_expected.to route(:post, "/commands").to(action: :create) }
end
