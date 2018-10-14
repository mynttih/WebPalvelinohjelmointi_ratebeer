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

  def favorite_style
    return nil if ratings.empty?

    ratings_grouped = ratings.group_by{ |r| r.beer.style }
    style_avgs = get_style_averages(ratings_grouped)
    style_avgs.key(style_avgs.values.max)
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings_grouped = ratings.group_by{ |r| r.beer.brewery }
    brewery_avgs = get_brewery_averages(ratings_grouped)
    brewery_avgs.key(brewery_avgs.values.max)
  end

  def get_style_averages(ratings_grouped_by_style)
    avgs_by_style = {}
    ratings_grouped_by_style.keys.each do |style|
      avgs_by_style[style] = get_list_of_ratings_average(ratings_grouped_by_style[style])
    end
    avgs_by_style
  end

  def get_brewery_averages(ratings_grouped_by_brewery)
    avgs_by_brewery = {}
    ratings_grouped_by_brewery.keys.each do |brewery|
      avgs_by_brewery[brewery] = get_list_of_ratings_average(ratings_grouped_by_brewery[brewery])
    end
    avgs_by_brewery
  end

  def get_list_of_ratings_average(ratings)
    scores = ratings.map(&:score)
    scores.inject{ |sum, score| sum + score }.to_f / scores.size
  end

  def self.top(number)
    sorted_by_rating_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count || 0) }
    sorted_by_rating_in_desc_order[0..number - 1]
  end
end
