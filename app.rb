# require 'sinatra'
# require 'sinatra/reloader'
require 'dotenv'
require 'httparty'
require 'json'
require 'pry'
require 'nokogiri'

Dotenv.load


def load_latest_show
  latest_setlist = HTTParty.get("https://api.phish.net/api.json?api=2.0&method=pnet.shows.setlists.latest")

  jsoned = JSON.parse(latest_setlist)
  latest_setlist_data = jsoned[0]["setlistdata"]
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



def load_songs_and_gaps

  load_song_page = HTTParty.get("http://phish.net/song/")
  parsed_song_page = Nokogiri::HTML(load_song_page)
  song_rows = parsed_song_page.css('tr')

  songs_hash = {}

  song_rows.each do |song|
    song_info = {}
    title = song.children.children[0].text
    artist = song.children.children[1].text
    if song.children.children[5]
      gap = song.children.children[5].text
    else
      gap = nil
    end

    song_info["artist"] = artist
    song_info["gap"] = gap

    songs_hash[title] = song_info
  end

  # removes first row (column header)

  songs_hash.delete("Song Name")
  songs_hash
end




# BUILD LOAD RANDOM SHOW FOR TESTING
