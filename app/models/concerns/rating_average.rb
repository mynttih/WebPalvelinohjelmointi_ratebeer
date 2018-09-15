module RatingAverage

    def average_rating
        scores = self.ratings.map{ |rating| rating.score }
        scores.inject{ |sum, score| sum + score}.to_f / scores.size
    end
end