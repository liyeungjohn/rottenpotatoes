class Movie < ActiveRecord::Base
    def self.allRatings
	result = []
	Movie.all.each do |movie|
	    currRating = movie.rating
	    if !result.include?(currRating)
		result << currRating
	    end
	end
	return result
    end
end
