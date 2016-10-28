TopMovies
========

TopMovies is a console application to manipulate the data from the list of top 250 IMDB movies.
Usage
==========

Installation
-------------------
$ gem install topmovies

Before you can use all the features of the library you want to connect a data file with movies

```ruby
  file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'
  if File.exist?(file_name)
    File.open(file_name)
  else
    puts 'Ошибка. Файл отсутствует!'
    exit
  end
```

####MovieCollection

MovieCollection, created in the application, allows you to extract data and show filtered and sorted lists of movies, based on different criteria, also it can display any statistics on films.

```ruby
  # make collection of movies
  movies = TopMovies::MovieCollection.new(file_name)
  # => <TopMovies::MovieCollection:0x00000002ab6da8>

  #show comedies
  movies.filter(genre: 'Comedy')
  # => <TopMovies::ModernMovie:0x00000002ff7038>
  # => <TopMovies::AncientMovie:0x00000002fdcaa8>
  # => <TopMovies::NewMovie:0x00000002fd5ca8>
  # => ...

  # show sorted list movies by year
  movies.sort_by(:year)
  # => The Kid - 1921
  # => The Gold Rush - 1925
  # => The General - 1926
  # => Metropolis - 1927
  # =>  ...

  # show count of movies maked each author
  movies.stats(:author)
  # => {"Adam Elliot"=>1, "Akira Kurosawa"=>6, "Alejandro González Iñárritu"=>1, ... }

  # get first movie
  movie = movies.all.first

  # number famous actors played in this movie
  movie.actors.count
  # => 3

  # Arnold Shwarzenegger played in this movie
  movie.actors.include?('Arnold Shwarzenegger')
  # => false
```

####Cinema

  Netflix and Theatre are cinemas based on MovieCollection have cashboxes that can accept payments and sell tickets.

#####Netflix

```ruby
  # make online cinema Netflix
  online = TopMovies::Netflix.new(file_name)
  # => #<TopMovies::Netflix:0x000000021e0558>

  # show newest Drama
  online.show(genre: 'Drama', period: :new)
  # => Downfall — новинка, вышло 12 лет назад!

  # create component filter
  movies = online.show do |movie|
    !movie.title.include?('Terminator') && \
      movie.genre[0].include?('Action') && \
      movie.year > 2003
  end
  # genre of movies is Action and not have Terminator and newer 2003
  # => Elite Squad: The Enemy Within — новинка, вышло 6 лет назад!

  # put cash to cashbox of Netflix
  online.pay(35)
  # => 35.00
```

#####Theatre

```ruby
  # make usual cinema Theatre
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
  # => <TopMovies::Netflix:0x000000011152a0>

  # you can add period into Theatre
  theatre.period '21:00'..'23:00' do
    description 'Еще один сеанс'
    filters genre: 'Sci-Fi', year: 1900..1980
    price 13
    hall :red
  end

  # you can buy a ticket
  theatre.buy_ticket('10:20')
  # => Утренний сеанс - 09:00..12:00 : Фильм: The Gold Rush - 10.00 ₴
  theatre.buy_ticket('13:20')
  # => Спецпоказ - 12:00..16:00 : Фильм: The Terminator - 50.00 ₴
  theatre.buy_ticket('17:20')
  # => Вечерний сеанс - 16:00..20:00 : Фильм: Interstellar - 20.00 ₴
  theatre.buy_ticket('19:20', hall: :green)
  # => Вечерний сеанс для киноманов - 19:00..22:00 : Фильм: The Maltese Falcon - 30.00 ₴

  # if you want you can check the money in cashbox of Theatre
  theatre.cash
  # => 110.00

  # yet you can spend cash collection into cashbox of Theatre
  theatre.take('Bank')
  # => Проведена инкассация
  # => 0.00

```
####Additional info

  In addition, the application can get the budget for each film with IMDb site, extract the posters and film title translation into other languages with TMDB site, and renders html page with all the movies.

```ruby
  # get the film's budget
  movie = movies.all[112]
  movie.budget
  # => $14,400,000

  # get a poster for the film
  movie = movies.filter(title: 'Terminator')
  movie.poster


  # receive translations of the film in other language
  movie = movies.filter(title: '12 Angry Men')
  movie.translations

  # create HTML markup
  movies.render_html
  # => html markup
```

####Run library from CLI

  There is an executable file (bin/netflix), which can be run from the command line
  passing it parameters, and receive the filtered data.

```ruby
  # run
  $ bin/netflix netflix --pay 25 --show genre:Comedy
  # => 25.00
  # => The General — старый фильм (1926 год)
  $ bin/netflix netflix --pay 25 --show year:1988
  # => 25.00
  # => The General — старый фильм (1926 год)
```

Other methods for manipulating data list IMDB top 250 films described to documentation

Author
--------------
Serhii Dmytrakov <clamdm@mail.ru>
