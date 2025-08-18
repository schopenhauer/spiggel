require 'sinatra'
require 'net/http'
require 'uri'
require 'dotenv'
Dotenv.load

CUSTOM_URL = ENV['CUSTOM_URL'] || 'https://www.rtl.lu'

helpers do
  def mirror_request(path, query_string, headers)
    url = URI.join(CUSTOM_URL.chomp('/'), path)
    url.query = query_string unless query_string.nil? || query_string.empty?

    req = Net::HTTP::Get.new(url)
    # Forward main headers (except host)
    headers.each do |k, v|
      req[k] = v unless k.downcase == 'host'
    end

    Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
      http.request(req)
    end
  rescue => e
    halt 502, "Mirroring failed: #{e.message}"
  end
end

get '/*' do
  response = mirror_request(request.path, request.query_string, request.env.select { |k, _| k.start_with?('HTTP_') })
  content_type response.content_type
  status response.code.to_i
  response.body
end
