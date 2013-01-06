require_relative 'environment'
require 'sinatra'
require 'sinatra/partial'
require 'json'
helpers do
end

configure do
  mime_type :csv, 'application/octet-stream'
end

get '/' do
  haml :index
end

get '/download' do
  attachment URI.decode(params[:filename])
  URI.decode(params[:data])
end

put '/' do
  csv_filename = env['HTTP_X_FILENAME'].sub(/\.qif\z/, ".csv")
  qif = Qif.new(request.body.read)
  content_type :json
  { :filename => csv_filename, :data => qif.to_csv }.to_json
end
