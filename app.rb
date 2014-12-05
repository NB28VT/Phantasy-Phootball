# require 'sinatra'
# require 'sinatra/reloader'
require 'dotenv'
require 'httparty'
require 'json'
require 'pry'
require 'nokogiri'

Dotenv.load


def load_latest_show
  random_setlist = HTTParty.get("https://api.phish.net/api.json?api=2.0&method=pnet.shows.setlists.latest")

  jsoned = JSON.parse(random_setlist)
  random_setlist_data = jsoned[0]["setlistdata"]
  setlist = Nokogiri::HTML(random_setlist_data)

  set_one = []

  first_set_data = setlist.css('p')[0]

  first_set_data.css('a').each do |song|
    set_one << song.children.text
  end

  set_two = []

  second_set_data = setlist.css('p')[1]

  second_set_data.css('a').each do |song|
    set_two << song.children.text
  end

  encore = []

  encore_data = setlist.css('p')[2]

  encore_data.css('a').each do |song|
    encore << song.children.text
  end
end


def load_song_list
# IN THE FUTURE, LOAD TO DB FOR ACCESS
  contents = File.read("song_list_raw.txt")
  lines = File.readlines("song_list_raw.txt")

  songs = []

  lines.each do |line|
    song = line.split("\"")[1]
    songs << song
  end
  songs = songs.compact
end
