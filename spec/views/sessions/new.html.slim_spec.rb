# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/new", type: :view do
  describe "the new user form" do
    it "renders an email input" do
      render
      expect(rendered).to match(/input.*name="user\[email\]"/)
    end

    it "renders a password input" do
      render
      expect(rendered).to match(/input.*name="user\[password\]"/)
    end

    it "renders a submit button" do
      render
      expect(rendered).to match(/input.*type="submit"/)
    end
  end
end
