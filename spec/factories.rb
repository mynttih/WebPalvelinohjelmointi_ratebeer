FactoryBot.define do
  factory :style do
    name { "European Pale Lager" }
    description { "description" }
  end

  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 } 
  end

  factory :beer do
    name { "anonymous" }
    style
    brewery
  end

  factory :rating do
    beer
  end
end