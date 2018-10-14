require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

describe "Ratings page" do
  let!(:user1) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Vilma" }
  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  describe "when ratings exist" do
    before :each do
      @ratings1 = [10, 20, 15, 7, 9]
      @ratings1.each do |rating|
        create_beer_with_rating({ user: user1 }, rating)
      end
      @ratings2 = [5, 22, 12, 34, 6]
      @ratings2.each do |rating|
        create_beer_with_rating({ user: user2 }, rating)
      end
      @total_ratings = @ratings1.count + @ratings2.count
    end

    it "shows all ratings made by user on user page" do
      sign_in(username: "Pekka", password: "Foobar1")

      visit user_path(user1)

      @ratings1.each do |rating|
        expect(page).to have_content rating
      end
    end

    it "rating deleted by user is removed from system" do
      sign_in(username: "Pekka", password: "Foobar1")

      visit user_path(user1)
      expect{
        page.find('li', text: @ratings1[0]).click_link('delete')
      }.to change{Rating.count}.from(@total_ratings).to(@total_ratings-1)
    end
  end
end
