ENV['RACK_ENV'] = 'test'

require File.expand_path('../../app.rb', __FILE__)
require 'rspec'
require 'rack/test'
require 'database_cleaner'
require 'dm-rspec'

DatabaseCleaner.strategy = :truncation

RSpec.configure do |config|
  config.include(DataMapper::Matchers)
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
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

  context Exposition do
    it "creates a new exposition if there isn't one for today" do
      expect{Exposition.today}.to change{Exposition.count}.from(0).to(1)
    end

    it "returns the new exposition if there isn't one for today" do
      expect(Exposition.today).to be_a(Exposition)
    end

    it "returns the existing exposition if there is one for today" do
      exp = Exposition.create!(day_key: Exposition.key_for_day(Date.today))
      expect(Exposition.today).to eq(exp)
    end
  end

  context Entry do
    it { belongs_to(Exposition) }
  end

  context "actions" do
    describe "#get 'home'" do
      it "loads the homepage" do
        get '/'
        expect(last_response).to be_ok
      end
    end

    describe "#post 'new'" do
      it "loads correctly" do
        post '/', {}
        expect(last_response).to be_ok
      end

      it "creates a new entry" do
        expect{ post '/', {} }.to change{Entry.count}.from(0).to(1)
      end

      it "stores the text" do
        text = "This is some text"
        post '/', { entry: { text: text } }
        expect(Entry.last.text).to eq(text)
      end
    end
  end
end
