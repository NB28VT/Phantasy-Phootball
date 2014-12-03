require 'sinatra'
require 'sinatra/reloader'
require 'dotenv'
require 'httparty'
require 'json'
require 'pry'
require 'nokogiri'

Dotenv.load





# SUCCESFULLY RETURNS AN ARRAY OF ALL SONGS FROM RANDOM SHOW



random_setlist = HTTParty.get("https://api.phish.net/api.json?api=2.0&method=pnet.shows.setlists.random")

jsoned = JSON.parse(random_setlist)
random_setlist_data = jsoned[0]["setlistdata"]
setlist = Nokogiri::HTML(random_setlist_data)

setlist_array = []

setlist.css('a').each do |song|
  setlist_array << song.children.text
end
