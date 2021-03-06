require 'rails_helper'

RSpec.describe User, type: :model do
  # include ActionDispatch::TestProcess::FixtureFile

  before :each do
    @user = create(:user)
  end

  it 'can create new user' do
    expect(@user).to be_valid
  end

  it 'validates uniqueness of user email' do
    dublicated_user = build(:user, email: "butterbeerh@example.com")
    expect(dublicated_user).to_not be_valid
  end

  it "stores create user in table" do
    expect(User.count).to eq 1
  end

  describe 'validates presence' do
    let(:user) { User.new(name: 'Gandalf',
                            email: 'gandalf@example.com',
                            password: 'sauron1'
                          )
    }

    it "is not validated without name attribute" do
      user.name = nil
      expect(user).to_not be_valid
    end

    it "is not validated without email attribute" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is not validated without password attribute" do
      user.password = nil
      expect(user).to_not be_valid
    end
  end
end