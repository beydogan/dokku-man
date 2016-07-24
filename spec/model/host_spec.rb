require "rails_helper"

describe Host, type: :model do
  it "has a valid factory" do
    h = create :host
    expect(h).to be_valid
  end
end