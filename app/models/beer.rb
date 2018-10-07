class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  belongs_to :style

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end
end
