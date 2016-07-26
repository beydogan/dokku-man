require "rails_helper"

describe Server, type: :model do
  it "has a valid factory" do
    h = create :server
    expect(h).to be_valid
  end
end