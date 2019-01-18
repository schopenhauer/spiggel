require 'sinatra'
require 'open-uri'
require 'dotenv'
Dotenv.load

URL = ENV['CUSTOM_URL'] || 'https://www.katsushikahokusai.org'

get '/' do
  dl(URL)
end

get '/*' do
  dl(URL + request.path)
end

private

def dl(url)
  uri = URI.parse(url)
  result = uri.read
  halt 200, {'Content-Type' => result.content_type}, result
end
