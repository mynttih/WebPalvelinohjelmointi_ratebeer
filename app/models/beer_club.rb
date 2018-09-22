class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :membership

  def to_s
    name
  end
end
