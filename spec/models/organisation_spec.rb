require 'rails_helper'
require 'helper_methods'

RSpec.describe Organisation, type: :model do
  include ActionDispatch::TestProcess::FixtureFile

  it "can create new organisation" do
    organisation = add_new_org
    assert organisation.save
    expect(organisation).to be_valid
  # end
  end

  it "validates uniqueness of organisation" do
    org_1 = add_new_org
    org_2 = Organisation.create(name: 'Hogwarts', hourly_rate: 12.50)
    expect(org_2).to_not be_valid
  end

  it "validates presence of name" do
    org = Organisation.create(hourly_rate: 12.50)
    expect(org).to_not be_valid
  end

  it "validates presence of hourly rate" do
    org = Organisation.create(name: 'Hogwarts')
    expect(org).to_not be_valid
  end
end