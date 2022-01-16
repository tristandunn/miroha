# frozen_string_literal: true

require "rails_helper"

describe "commands/whisper/_unknown.html.erb", type: :view do
  subject(:html) do
    render(
      partial: "commands/whisper/unknown",
      locals:  { target_name: target_name }
    )

    rendered
  end

  let(:target_name) { generate(:name) }

  it "renders the unknown message" do
    expect(html).to have_command_row(
      "td[colspan=2]",
      text: t("commands.whisper.unknown.message", target_name: target_name)
    )
  end
end
