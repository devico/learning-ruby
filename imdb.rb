require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'progress-bar'


page = Nokogiri::HTML(open("http://www.imdb.com/title/tt0482571/?ref_=chttp_tt_51"))
puts page.class   # => Nokogiri::HTML::Document

tl = page.css('.originalTitle').map do |el|
  el.text
end

bd = page.css('div.txt-block:nth-child(11)').map do |el|
  el.text.split(' ')[1]
end

a = { 'title' => tl[0], 'budget' => bd[0] }.to_yaml

puts a