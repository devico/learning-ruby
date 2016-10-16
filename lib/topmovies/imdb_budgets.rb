require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets

  PATH_BUDGETS = File.dirname(File.expand_path('data/budgets/*.*',__dir__))

  def take_budget_from_file(file_name)
    YAML::load_file(File.open("#{PATH_BUDGETS}/#{file_name}"))[file_name[0,9]]
  end

  def take_budget_from_imdb(id)
    data = take_info
    data = if data =~ /^(\$|\€|\£|DEM|AUD|FRF)/
            data
           else
             nil
           end
    File.write("#{PATH_BUDGETS}/#{id}.yml", {id => data}.to_yaml)
  end

  def take_info
    Nokogiri::HTML(open(self.link)).css('div.txt-block:nth-child(11)').text.split(' ')[1]
  end
end
