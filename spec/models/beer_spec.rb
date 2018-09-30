require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "created beer is saved when name, style and brewery are given" do
    brewery = Brewery.create name: "testiPanimo", year: 2000
    beer = Beer.create name: "testiOlut", style: "Lager", brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "created beer is not saved when name not given" do
    brewery = Brewery.create name: "testiPanimo", year: 2000
    beer = Beer.create style: "Lager", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "created beer is not saved when name not given" do
    brewery = Brewery.create name: "testiPanimo", year: 2000
    beer = Beer.create name: "testiOlut", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
