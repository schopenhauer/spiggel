require 'sinatra'
require 'open-uri'
require 'dotenv'

Dotenv.load

URL = ENV['CUSTOM_URL'] || 'https://www.katsushikahokusai.org'

get '/?*?' do
  url = URL.chomp('/') + request.path
  dl(url)
end

private

def dl(url)
  result = URI.parse(url).read
  halt 200, { 'Content-Type' => result.content_type }, result
end
