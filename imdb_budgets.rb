require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets

  def take_budget_from_file(file_name)
    YAML::load_file(File.open(file_name))["budget"]
  end

  def take_budget_from_imdb(id)
    data = take_info
    raise ArgumentError, "Нет данных о бюджете данного фильма" if data.is_a?(Array)
    File.write("#{id}.yml", data)
    data.scan(/(\$.*0)/)
  end

  def take_info
    page = Nokogiri::HTML(open(self.link))
    imdb_id = page.at("meta[property='pageId']")['content']
    budget = page.css('div.txt-block:nth-child(11)').map do |el|
      el.text.split(' ')[1]
    end
    movie_info = [imdb_id, budget[0]]
    budget = if movie_info[1] =~ /^(\$|\€)/
      { 'imdb_id' => movie_info[0], 'budget' => movie_info[1] }.to_yaml
    else
      movie_info
    end
  end

end
