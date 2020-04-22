require "rails_helper"

RSpec.describe "As a visitor", type: :feature do
  it "I see a welcome message and access to navbar on landing page." do
    visit "/"

    expect(page).to have_content("Welcome!")
    expect(page).to have_content("Log In")
  end
end
