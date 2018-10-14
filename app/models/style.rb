class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def self.top(number)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating || 0) }
    sorted_by_rating_in_desc_order[0..number - 1]
  end
end
