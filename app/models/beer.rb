class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  belongs_to :style

  validates :name, presence: true
  validates :style, presence: true

  def self.top(n)
    sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0..n-1]
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
