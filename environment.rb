require 'rubygems'
Dir['models/*.rb'].each do |model|
  require_relative model
end
