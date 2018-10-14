require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka", password: "Secret1", password_confirmation: "Secret1"

    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "is not saved when password is too short" do
    user = User.create username: "Pekka", password: "Se1", password_confirmation: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved when password contains only letters" do
    user = User.create username: "Pekka", password: "Secret", password_confirmation: "Secret"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }
    let!(:style1) { FactoryBot.create :style }
    let!(:style2) { FactoryBot.create :style, name: "American Pale Ale" }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_many_ratings({ user: user, style: style1 }, 32, 20, 15, 35, 18)
      create_beers_with_many_ratings({ user: user, style: style2 }, 12, 20, 15, 7, 5)

      expect(user.favorite_style).to eq(style1)
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }
    let(:brewery1) { FactoryBot.create(:brewery, name:"anonymous1") }
    let(:brewery2) { FactoryBot.create(:brewery, name:"anonymous2") }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_many_ratings({ user: user, brewery: brewery1 }, 10, 20, 15, 7, 9)
      create_beers_with_many_ratings({ user: user, brewery: brewery2 }, 23, 20, 15, 27, 30)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
end
