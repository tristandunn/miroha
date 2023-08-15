# frozen_string_literal: true

require "rails_helper"

describe "commands/attack/_killed.html.erb" do
  subject(:html) do
    render(
      partial: "commands/attack/killed",
      locals:  {
        damage:      damage,
        target_name: target_name
      }
    )

    rendered
  end

  let(:damage)      { rand(1..10) }
  let(:target_name) { generate(:name) }

  it "renders the killed message" do
    expect(html).to have_message_row(
      "td",
      text: t("commands.attack.killed.message", target_name: target_name, count: damage)
    )
  end
end
