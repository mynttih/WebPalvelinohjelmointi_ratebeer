class Brewery < ApplicationRecord
    include RatingAverage

    has_many :beers, dependent: :destroy
    has_many :ratings, through: :beers

    #def average_rating
    #    scores = self.ratings.map{ |rating| rating.score }
    #    scores.inject{ |sum, score| sum + score}.to_f / scores.size
    #end

    def to_s
        "#{self.name}"
    end
end
