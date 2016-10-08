require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets

  def take_budget_from_file(file_name)
    YAML::load_file(File.open(file_name))[file_name[0,9]]
  end

  def take_budget_from_imdb(id)
    data = take_info
    data = if data.nil?
        nil
      elsif !data.include?("$" || "DEM" || "AUD" || "£" || "€")
        nil
      else
        data
      end
    File.write("#{id}.yml", {id => data}.to_yaml)
  end

  def take_info
    Nokogiri::HTML(open(self.link)).css('div.txt-block:nth-child(11)').text.split(' ')[1]
  end
end