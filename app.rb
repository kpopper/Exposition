require 'rubygems'
require 'sinatra'
require 'haml'
require 'data_mapper'
require 'dm-migrations'
require 'dotenv'
require 'rack-flash'
# require 'omniauth-twitter'

Dotenv.load ".env.#{ENV['RACK_ENV']}"
enable :sessions
use Rack::Flash

# use OmniAuth::Builder do
#   provider :twitter, ENV['TWITTER_CONSUMER_KEY'], ENV['TWITTER_CONSUMER_SECRET']
# end

DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:db/exposition_development.db')

class Person
  def self.people
    %w(man woman person child)
  end
  def self.adjectives
    %w(old young jewish disabled American)
  end
  def self.form_person
    self.adjectives.sample + " " + self.people.sample
  end
end

class Place
  def self.random
    self.places.sample
  end
  def self.places
    %w(a\ beach a\ harbour the\ woods a\ village the\ city train\ station a\ quiet\ lane)
  end
end

class Exposition
  include DataMapper::Resource

  property :day_key, Integer, key: true
  property :date, Date
  property :person, String
  property :place, String

  has n, :entries

  def self.today
    today = Date.today
    key = key_for_day today

    Exposition.get(key) ||
      Exposition.create!(date: today, day_key: key, person: Person.form_person, place: Place.random)
  end

  private

  def self.key_for_day(day)
    seconds_in_a_day = 60 * 60 * 24
    (day.to_time.to_i / seconds_in_a_day).to_i
  end
end

class Entry
  include DataMapper::Resource

  property :id, Serial, key: true
  property :text, Text

  belongs_to :exposition, required: false
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/' do
  @exposition = Exposition.today
  haml :index
end

post '/' do
  @exposition = exposition_for_today
  @entry = @exposition.entries.create params
  flash[:notice] = "Your story has been stored. Come back tomorrow for more inspiration!"
  haml :index
end

private
def exposition_for_today
  today = Date.today
  key = key_for_day today

  Exposition.get(key) ||
    Exposition.create!(date: today, day_key: key, person: Person.form_person, place: Place.random)
end
def key_for_day(day)
  seconds_in_a_day = 60 * 60 * 24
  (day.to_time.to_i / seconds_in_a_day).to_i
end
