require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets
  def take_budget_from_file(file_name)
    Dir.chdir File.expand_path( File.join( File.dirname(__FILE__), "..", "data", "budgets") )
    YAML::load_file(File.open(file_name))[file_name[0,9]]
  end

  def take_budget_from_imdb(id)
    data = take_info
    data = if data =~ /^(\$|\€|\£|DEM|AUD|FRF)/
            data
           else
             nil
           end
    Dir.chdir File.expand_path( File.join( File.dirname(__FILE__), "..", "data", "budgets") )
    File.write("#{id}.yml", {id => data}.to_yaml)
  end

  def take_info
    Nokogiri::HTML(open(self.link)).css('div.txt-block:nth-child(11)').text.split(' ')[1]
  end
end
