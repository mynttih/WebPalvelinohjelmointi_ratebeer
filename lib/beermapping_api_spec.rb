require 'rails_helper'

describe "BeermappingApi" do
  it "When HTTP GET returns one entry, it is parsed and returned" do

    canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Gallows Bird</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("espoo")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("Gallows Bird")
    expect(place.street).to eq("Eerikinkatu 18")
  end

  it "When HTTP GET returns no entries, empty array is returned" do

    canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*mikkeli/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("mikkeli")

    expect(places.size).to eq(0)
  end

  it "When HTTP GET returns many entries, they are parsed and returned" do

    canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18859</id><name>Saimaan Juomatehdas</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18859</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18859&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18859&amp;d=1&amp;type=norm</blogmap><street>Meijerinkatu 4</street><city>Lappeenranta</city><state></state><zip>53500</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21540</id><name>Tuju</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21540</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21540&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21540&amp;d=1&amp;type=norm</blogmap><street>Meijerinkatu 4</street><city>Lappeenranta</city><state>Ita-Suomen Laani</state><zip>53500</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*lappeenranta/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    places = BeermappingApi.places_in("lappeenranta")

    expect(places.size).to eq(2)
    place1 = places.first
    expect(place1.name).to eq("Saimaan Juomatehdas")
    expect(place1.street).to eq("Meijerinkatu 4")
    place2 = places.second
    expect(place2.name).to eq("Tuju")
    expect(place2.street).to eq("Meijerinkatu 4")
  end
end