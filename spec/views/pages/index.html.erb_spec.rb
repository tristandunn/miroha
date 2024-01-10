# frozen_string_literal: true

require "rails_helper"

describe "pages/index.html.erb" do
  subject(:html) do
    render template: "pages/index"

    rendered
  end

  before do
    without_partial_double_verification do
      allow(view).to receive(:signed_out?).and_return(true)
    end
  end

  it "renders the header" do
    expect(html).to have_css("h1", text: t("title"))
  end

  it "links to the new account path" do
    expect(html).to have_css(%(a[href="#{new_account_path}"]),
                             text: t("pages.index.new_account"))
  end

  it "links to the new session path" do
    expect(html).to have_css(%(a[href="#{new_sessions_path}"]),
                             text: t("pages.index.sign_in"))
  end

  context "when signed in" do
    before do
      without_partial_double_verification do
        allow(view).to receive(:signed_out?).and_return(false)
      end
    end

    it "does not link to the new account path" do
      expect(html).to have_no_css(%(a[href="#{new_account_path}"]),
                                  text: t("pages.index.new_account"))
    end

    it "does not link to the new session path" do
      expect(html).to have_no_css(%(a[href="#{new_sessions_path}"]),
                                  text: t("pages.index.sign_in"))
    end
  end
end
