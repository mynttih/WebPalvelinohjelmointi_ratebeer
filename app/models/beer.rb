class Beer < ApplicationRecord
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    #def average_rating
    #    scores = self.ratings.map{ |rating| rating.score }
    #    scores.inject{ |sum, score| sum + score}.to_f / scores.size
    #end

    def to_s
        "#{self.name}, #{self.brewery.name}"
    end
end
