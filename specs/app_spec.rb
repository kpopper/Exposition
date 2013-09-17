ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app.rb', __FILE__)
require 'rspec'
require 'rack/test'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
  end

  context Person do
    it "picks an adjective and a person" do
      person = Person.form_person
      person_bits = person.split(' ')
      expect(Person.adjectives).to include(person_bits[0])
      expect(Person.people).to include(person_bits[1])
    end
  end

  context Place do
    it "picks a valid place" do
      place = Place.random
      expect(Place.places).to include(place)
    end
  end
end
