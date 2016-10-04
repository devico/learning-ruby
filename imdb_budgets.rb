require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets

  def take_budget_from_file(id, file_name)
    item = YAML::load_stream(File.open(file_name)).select do |el|
      el["imdb_id"].include?(id)
    end
    if item.empty?
      element = take_budget_from_imdb(id, file_name)
    else
      item[0]["budget"]
    end
  end

  def take_budget_from_imdb(id, file_name)
    data = create_yml
    raise ArgumentError, "Нет данных о бюджете данного фильма" if data.is_a?(Array)
    budgetfile = File.open(file_name, 'a')
    put_to_file(budgetfile, data)
    budgetfile.close
    data.scan(/(\$.*0)/)
  end

  def create_yml
    page = Nokogiri::HTML(open(self.link))
    movie_info = take_info(page)
    data = info_to_yml(movie_info)
  end

  def take_info(page)
    imdb_id = page.at("meta[property='pageId']")['content']
    budget = page.css('div.txt-block:nth-child(11)').map do |el|
      el.text.split(' ')[1]
    end
    [imdb_id, budget[0]]
  end

  def info_to_yml(movie_info)
    if movie_info[1] =~ /^(\$|\€)/
      { 'imdb_id' => movie_info[0], 'budget' => movie_info[1] }.to_yaml
    else
      movie_info
    end
  end

  def put_to_file(budgetfile, data)
    budgetfile.puts data
  end
end
