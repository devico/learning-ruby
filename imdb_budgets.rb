require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'ruby-progressbar'
module ImdbBudgets

  def take_budget
    file_name = 'budget.yml'
    if File.exist?(file_name)
      YAML.load_file(File.read(file_name)).each { |item| puts item }
    else
      budgetfile = File.open(file_name, 'w')
      create_yml(budgetfile)
      budgetfile.close
    end
  end

  def create_yml(budgetfile)
    pages = obtain_pages
    movie_info = take_info(pages)
    data = info_to_yml(movie_info)
    put_to_file(budgetfile, data)
  end

  def obtain_pages
    progressbar = ProgressBar.create
    progressbar.total = @collection.size
    pages = @collection.map do |film|
      progressbar.increment
      Nokogiri::HTML(open(film.link))
    end
  end

  def take_info(pages)
    info = pages.map do |mp|
      imdb_id = mp.at("meta[property='pageId']")['content']
      budget = mp.css('div.txt-block:nth-child(11)').map { |el| el.text.split(' ')[1] }
      info = [imdb_id, budget[0]]
    end
  end

  def info_to_yml(movie_info)
    budgets = movie_info.map { |i| { 'imdb_id' => i[0], 'budget' => i[1] }.to_yaml if i[1] =~ /^(\$|\€)/ }.compact
  end

  def put_to_file(budgetfile, data)
    budgetfile.puts data
  end

end
