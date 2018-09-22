module RatingAverage
  def average_rating
    return 0 if ratings.empty?

    scores = ratings.map(&:score)
    scores.inject{ |sum, score| sum + score }.to_f / scores.size
  end
end
