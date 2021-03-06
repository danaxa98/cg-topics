ENV['APP_ENV'] = 'test'

require_relative '../app.rb'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe 'The HelloWorld App' do
  it "says hello" do
    get '/'
    last_response.ok?
    last_response.body.must_equal 'Hello Sinatra!'
  end
end

describe "GET on /api/users/:id" do
  before do
    User.delete_all
    User.create(
      name: "paul",
      email: "paul@gmail.com",
      password: "foo",
      bio: "Student")
  end



  it "Should retiurn user by name" do
    get '/api/users/paul'
    last_response.ok?
    attributes = JSON.parse(last_response.body)
    attributes["name"].must_equal "paul"
  end

  it "Should return users email too" do
    get '/api/users/paul'
    last_response.ok?
    attributes = JSON.parse(last_response.body)
    attributes["email"].must_equal "paul@gmail.com"
  end
  it "Should retiurn user by name" do
    get '/api/users/paul'
    last_response.ok?
    attributes = JSON.parse(last_response.body)
    attributes.key?("password").must_equal false
  end
end

describe "POST on /api/users" do
  it "Should create a user" do
    post '/api/users', {
      name: "manzi",
      email: "manzi@gmail.com",
      password: "lotus",
      bio: "Lotus CEO"}.to_json
    last_response.ok?
    get '/api/users/manzi'
    last_response.ok?
    attributes = JSON.parse(last_response.body)
    attributes["email"].must_equal "manzi@gmail.com"
    attributes["name"].must_equal "manzi"
    attributes["bio"].must_equal "Lotus CEO"
  end
end