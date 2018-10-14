require 'rails_helper'

describe "Beer" do
  let!(:brewery) { FactoryBot.create(:brewery) }
  let!(:user) { FactoryBot.create :user }
  let!(:style) { FactoryBot.create :style }

  it "is added when name is valid" do
    sign_in(username: "Pekka", password: "Foobar1")

    visit new_beer_path
    fill_in('beer_name', with: 'valid')
    select('European Pale Lager', from: 'beer_style')
    select('anonymous', from: 'beer_brewery_id')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not added when name is not valid" do
    sign_in(username: "Pekka", password: "Foobar1")
  
    visit new_beer_path
    fill_in('beer_name', with: '')
    select('European Pale Lager', from: 'beer_style')
    select('anonymous', from: 'beer_brewery_id')

    click_button("Create Beer")

    expect(Beer.count).to eq(0)
  end
end
