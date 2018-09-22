class Brewery < ApplicationRecord
  include RatingAverage

  validate :less_than_or_equal_to_current_year

  def less_than_or_equal_to_current_year
    if year > Time.now.year
      errors.add(:year, "must be less than or equal to the current year")
    end
  end

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to_current_year: true,
                                   only_integer: true }

  def to_s
    name
  end
end
