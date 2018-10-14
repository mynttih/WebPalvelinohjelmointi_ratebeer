class Brewery < ApplicationRecord
  include RatingAverage

  validate :less_than_or_equal_to_current_year

  def less_than_or_equal_to_current_year
    errors.add(:year, "must be less than or equal to the current year") if year > Time.now.year
  end

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to_current_year: true,
                                   only_integer: true }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def self.top(number)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0..number - 1]
  end

  def to_s
    name
  end
end
