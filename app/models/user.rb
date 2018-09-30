class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :membership

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*?[A-Z])(?=.*?[0-9])/ }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end
end
