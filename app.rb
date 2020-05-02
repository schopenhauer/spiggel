require 'sinatra'
require 'open-uri'
require 'dotenv'
Dotenv.load

URL = ENV['CUSTOM_URL'] || 'https://www.katsushikahokusai.org'

get '/?*?' do
  url = URL.chomp('/') + request.path
  result = URI.parse(url).read
  content_type result.content_type
  result
end
