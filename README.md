TopMovies
========

TopMovies is a console application to manipulate the data from the list of top 250 IMDB movies.

MovieCollection, created in the application, allows you to extract data and show filtered and sorted lists of movies, based on different criteria, also it can display any statistics on films.

Netflix and Theatre are cinemas based on MovieCollection have cashboxes that can accept payments and sell tickets.

In addition, the application can get the budget for each film with IMDb site, extract the posters and film title translation into other languages with TMDB site, and renders html page with all the movies

Installation
-------------------
$ gem install topmovies

Usage
-------------------

```ruby
    file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'
    if File.exist?(file_name)
      File.open(file_name)
    else
      puts 'Ошибка. Файл отсутствует!'
      exit
    end

  movies = TopMovies::MovieCollection.new(file_name)
  movies.filter(genre: 'Comedy')
  movies.sort_by(:year)

  online = TopMovies::Netflix.new(file_name)
  online.show(genre: 'Drama', period: :new)

  theatre =
    TopMovies::Theatre.new do
      hall :red, title: 'Красный зал', places: 100
      hall :blue, title: 'Синий зал', places: 50
      hall :green, title: 'Зелёный зал (deluxe)', places: 12

      period '09:00'..'12:00' do
        description 'Утренний сеанс'
        filters genre: 'Comedy', year: 1900..1980
        price 10
        hall :red, :blue
      end

      period '12:00'..'16:00' do
        description 'Спецпоказ'
        title 'The Terminator'
        price 50
        hall :green
      end

      period '16:00'..'20:00' do
        description 'Вечерний сеанс'
        filters genre: %w(Action Drama), year: 2007..Time.now.year
        price 20
        hall :red, :blue
      end

      period '19:00'..'22:00' do
        description 'Вечерний сеанс для киноманов'
        filters year: 1900..1945, exclude_country: 'USA'
        price 30
        hall :green
      end
  end

  theatre.period '21:00'..'23:00' do
   description 'Еще один сеанс'
   filters genre: 'Sci-Fi', year: 1900..1980
   price 13
   hall :red
 end

 theatre.buy_ticket('19:20', hall: :green)
```

Other methods for manipulating data list IMDB top 250 films described to documentation

Examples
-----------
####MovieCollection

```ruby
movies.filter(year: 2000) - show movies, created in 2000
movies.filter(genre: 'Comedy') - show comedies
movies.sort_by(:year) - show sorted list of movies by year
```

####Netflix

  Show all the drama from 2000 to present

```ruby
  online.show(genre: 'Drama', period: :new)
```

  See the amount of money at the cashbox

```ruby
  online.cash
```

  Define new filter and show movies of genre Sci-Fi make not UK

```ruby
  online.define_filter(:new_sci_fi) do |movie|
    movie.genre[0].include?('Sci-Fi') && \
      !movie.country.include?('UK')
  end
  puts online.show(new_sci_fi: true)
```

####Theatre

  Add new period

```ruby
  theatre.period '21:00'..'23:00' do
   description 'Еще один сеанс'
   filters genre: 'Sci-Fi', year: 1900..1980
   price 13
   hall :red
 end
```

  Buy tickets

```ruby
 theatre.buy_ticket('17:20')
 theatre.buy_ticket('19:20', hall: :green)
```

Features
------------

####MovieCollection

  Show list all films

```ruby
  movies.all
```

  Get a filtered list of movies by genre

```ruby
  movies.filter(genre: 'Comedy')
```

  Get a filtered list on the film by year

```ruby
  movies.filter(year: 2000)
  movies.filter(year: 1980..2000)
```

  Get a sorted list on the film by tear

```ruby
  movies.sort_by(:year)
```

  Obtain statistics on the number of films made by each director

```ruby
  movies.stats(:author)
```

  Display statistics by month

```ruby
  groups = movies.reject{ |f|
    !f.date.include?('-') }
    .group_by{ |f|
      Date.strptime( f.date, '%Y-%m').mon
    }.sort

  groups.map do |month, group|
    puts "#{ Date.strptime(month.to_s, '%m').strftime('%B') } - #{group.count}"
  end
```

  Get the number of films made outside the US

```ruby
  movies.each.count { |f| f.country != "USA" }
```

  Get a list of all directors alphabetically

```ruby
  movies
    .sort_by { |a| a.author.split(' ').reverse.join(" ") }
    .uniq(&:author)
    .each { |a| puts a.author}
```

  Get 10 comedies (the first on the release date)

```ruby
  movies
    .reject { |c| !c.genre.split(",").include?("Comedy")}
    .sort_by(&:year)
    .take(10)
    .each { |a| puts "#{a.title} - #{a.genre} - #{a.year}"}
```

  Get 5 longest movies

```ruby
  def show(f)
    puts "#{ f.title} (#{f.date} #{f.genre}) - #{f.length }"
  end

  movies
    .sort_by { |f| -f.length.to_i }
    .take(5)
    .each { |a| show(a) }
```

####Netflix

  At each call show different amounts of money withdrawn
  (1, 1.5, 3, 5 dollars, depending on the type of movie.

  There are 4 types of films:

* ancient - AncientMovie (1900-1945)
* classic - ClassicMovie (1945-1968)
* modern - ModernMovie (1968-2000)
* new - NewMovie (2000 until today)

Show newest drama

```ruby
  online.show(genre: 'Drama', period: :new)
```

  Component filter for movies

```ruby
  movies = online.show do |movie|
    !movie.title.include?('Terminator') && \
      movie.genre[0].include?('Action') && \
      movie.year > 2003
  end
```

  You can define your filter and display a list of films according to this filter

```ruby
  online.define_filter(:new_sci_fi) do |movie|
    movie.genre[0].include?('Sci-Fi') && \
      !movie.country.include?('UK')
  end
  online.show(new_sci_fi: true)

  online.define_filter(:not_spielberg) do |movie|
    !movie.author.include?('Steven Spielberg')
  end
  online.show(new_sci_fi: true, not_spielberg: true)

  online.define_filter(:country) do |movie|
    movie.genre.include?('Sci-Fi') && \
      !movie.author.include?('Steven Spielberg') && \
      !movie.country.include?('UK')
  end
```

  You can create a filter based on an existing

```ruby
  online.define_filter(:new_sci_fi) { |movie, year| movie.year > year }
  online.show(new_sci_fi: 2010)
  online.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
  online.show(newest_sci_fi: 2014)
```

  For different cinemas various online cash

```ruby
  online.cash != online1.cash
```

  See the amount of money at the cashbox

```ruby
  online.cash
```

  Put money in the cinema cashbox

```ruby
  online.pay(35)
```

  How much film

```ruby
  netflix.how_much?('The Terminator')
```

  Holding cash collection and reset cashbox
    - if who == Bank - going cash collection
    - if something else - an error occurs

```ruby
  netflix.take(Bank)
```


####Theatre

  See the amount of money at the cashbox

```ruby
  theatre.cash
```

  To know when you can see the right movie

```ruby
  theatre.when?('The Terminator')
```

  You can buy a ticket to a movie at a specific time

```ruby
  theatre.buy_ticket('10:20')
  theatre.buy_ticket('13:20')
  theatre.buy_ticket('17:20')
  theatre.buy_ticket('19:20', hall: :green)
```

  Holding cash collection and reset cashbox
    - if who == Bank - going cash collection
    - if something else - an error occurs

```ruby
  theatre.take(Bank)
```

####Movie

  Get some film in several ways

```ruby
  movie = movies.all.first
  movie = movies.all[0]
  movie = movies.filter(title: 'Terminator')
```

  Get the number of well-known actors, who played in the film

```ruby
  movie.actors.count
```

  Does the actor plays in the film

```ruby
  movie.actors.include?('Arnold Shwarzenegger')
```

  To know whether the film belongs to the genre

```ruby
  movies.first.has_genre?('Camedy')
```

  To know the film's budget

```ruby
  movie = movies.all[112]
  movie.budget
```

  Get a poster for the film

```ruby
  movie = movies.filter(title: 'Terminator')
  movie.poster
```

  Receive translations of the film in other language

```ruby
  movie = movies.filter(title: '12 Angry Men')
  movie.translations
```

####HTML

  Create HTML markup

```ruby
  movies.render_html
```

Author
--------------
Serhii Dmytrakov <clamdm@mail.ru>