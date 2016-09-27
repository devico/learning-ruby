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
      progressbar = ProgressBar.create
      progressbar.total = @collection.size
      budgetfile = File.open(file_name, 'w')
      create_yml(budgetfile, progressbar)
      budgetfile.close
    end
  end

  def create_yml(budgetfile, progressbar)
    @collection.map do |film|
      page = Nokogiri::HTML(open(film.link))
      bd = page.css('div.txt-block:nth-child(11)').map { |el| el.text.split(' ')[1] }
      data = { 'title' => film.title, 'budget' => bd[0] }.to_yaml
      budgetfile.puts data
      progressbar.increment
    end
  end
end
