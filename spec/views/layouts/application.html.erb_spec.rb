# frozen_string_literal: true

require "rails_helper"

describe "layouts/application.html.erb", type: :view do
  subject(:html) do
    render template: "layouts/application"

    rendered
  end

  it "renders the page title" do
    expect(html).to have_title(t("title"))
  end
end