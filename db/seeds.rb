# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "json"

url = "https://api.themoviedb.org/3/movie/top_rated?language=fr-FR&page=1"

token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MWVlNzRlOTIzNTM5OTAwMTU4NjY1MTE2NmI1YWNiOSIsIm5iZiI6MTc4NjYyODAxMy4yOTcsInN1YiI6IjZhN2RjN2FkZGUyZmI2M2FlNmI3YjIwNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.OgLg6hLg2MzA_jpKYfBGBDq2nq4wefep19U4C-SvIkk"

options = {
  "Authorization" => "Bearer #{token}",
  "accept" => "application/json"
}

response = URI.open(url, options).read
data = JSON.parse(response)

data["results"].each do |movie|
  next if movie["overview"].blank?

  poster_url = "https://image.tmdb.org/t/p/w500#{movie["poster_path"]}"
  Movie.create!(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: poster_url,
    rating: movie["vote_average"]
  )
end
