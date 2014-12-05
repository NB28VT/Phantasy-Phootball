require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'sinatra-activerecord'
require 'pry'


get '/PhantasyPhootball' do

  erb :index
end
