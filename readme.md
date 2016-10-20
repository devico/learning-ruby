TopMovies
========

TopMovies is a console application to manipulate the data from the list of top 250 IMDB movies.

1. MovieCollection, created in the application allows you to:

       * the names and rating of films,
       * the list of the longest films,
       * comedies list,
       * the list by producer and
       * display statistics by month
       * show the list of all films,
       * show a list sorted by date movies,
       * show a filtered list of movies by genre and country,
       * give statistics for: actor, year, month, country, genre

2. Netflix and Theatre are cinemas based on MovieCollection can:

       * show movies, using various filters,
       * cinemas have cashbox to receive money,
       * make it possible to buy tickets for a movie,
       * cinema it is also a schedule for the showing of films at different times and in different rooms

3. In addition, the application can:

       * get the budget for each film with IMDb site,
       * extract the posters and film title translation into other languages with TMDB site,
       * renders html page with all the movies

Installation
-------------------
$ gem install topmovies

Usage
-------------------

To use gem topmovies you need to do the following:

1. add to your file list of films

```sh
  file_name = ARGV[0] || '../lib/topmovies/data/movies.txt'
  if File.exist?(file_name)
    File.open(file_name)
  else
    puts 'Ошибка. Файл отсутствует!'
    exit
  end
```

2. create a Movie Collection on the basis of added movies list

```sh
  movies = TopMovies::MovieCollection.new(file_name)
```

3. create an online cinema Netflix

```sh
  online = TopMovies::Netflix.new(file_name)
```

4. create a normal cinema Theatre

```sh
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
```

After that you will be available to a large number of methods for manipulating data list IMDB top 250 films

Examples
------------

####MovieCollection

  # show list all films

```sh
  movies.all
```

  # get a filtered list of movies by genre

```sh
  movies.filter(genre: 'Comedy')
```

  # get a filtered list on the film by year

```sh
  movies.filter(year: 2000)
  movies.filter(year: 1980..2000)
```

  # get a sorted list on the film by tear

```sh
  movies.sort_by(:year)
```

  # obtain statistics on the number of films made by each director

```sh
  movies.stats(:author)
```

  # display statistics by month

```sh
  groups = movies.reject{ |f|
    !f.date.include?('-') }
    .group_by{ |f|
      Date.strptime( f.date, '%Y-%m').mon
    }.sort

  groups.map do |month, group|
    puts "#{ Date.strptime(month.to_s, '%m').strftime('%B') } - #{group.count}"
  end
```

  # get the number of films made outside the US

```sh
  movies.each.count { |f| f.country != "USA" }
```

  # get a list of all directors alphabetically

```sh
  movies
    .sort_by { |a| a.author.split(' ').reverse.join(" ") }
    .uniq(&:author)
    .each { |a| puts a.author}
```

  # get 10 comedies (the first on the release date)

```sh
  movies
    .reject { |c| !c.genre.split(",").include?("Comedy")}
    .sort_by(&:year)
    .take(10)
    .each { |a| puts "#{a.title} - #{a.genre} - #{a.year}"}
```

  # get 5 longest movies

```sh
  def show(f)
    puts "#{ f.title} (#{f.date} #{f.genre}) - #{f.length }"
  end

  movies
    .sort_by { |f| -f.length.to_i }
    .take(5)
    .each { |a| show(a) }
```

####Netflix

  # at each call show different amounts of money withdrawn
  (1, 1.5, 3, 5 dollars, depending on the type of movie
   There are 4 types of films:
    ancient - AncientMovie (1900-1945);
    classic - ClassicMovie (1945-1968);
    modern - ModernMovie (1968-2000);
    new - NewMovie (2000 until today)

   # show newest drama

```sh
  online.show(genre: 'Drama', period: :new)
```

  # component filter for movies

```sh
  movies = online.show do |movie|
    !movie.title.include?('Terminator') && \
      movie.genre[0].include?('Action') && \
      movie.year > 2003
  end
```

  # You can define your filter and display a list of films according to this filter

```sh
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

  # You can create a filter based on an existing

```sh
  online.define_filter(:new_sci_fi) { |movie, year| movie.year > year }
  online.show(new_sci_fi: 2010)
  online.define_filter(:newest_sci_fi, from: :new_sci_fi, arg: 2014)
  online.show(newest_sci_fi: 2014)
```

  # for different cinemas various online cash

```sh
  online.cash != online1.cash
```

  # see the amount of money at the cashbox

```sh
  online.cash
```

  # put money in the cinema cashbox

```sh
  online.pay(35)
```

  # how much film

```sh
  netflix.how_much?('The Terminator')
```

  # holding cash collection and reset cashbox
    - if who == Bank - going cash collection
    - if something else - an error occurs

```sh
  netflix.take(Bank)
```


####Theatre

  # see the amount of money at the cashbox

```sh
  theatre.cash
```

  # to know when you can see the right movie

```sh
  theatre.when?('The Terminator')
```

  # You can buy a ticket to a movie at a specific time

```sh
  theatre.buy_ticket('10:20')
  theatre.buy_ticket('13:20')
  theatre.buy_ticket('17:20')
  theatre.buy_ticket('19:20', hall: :green)
```

  # holding cash collection and reset cashbox
    - if who == Bank - going cash collection
    - if something else - an error occurs

```sh
  theatre.take(Bank)
```

####Movie

  # get some film in several ways

```sh
  movie = movies.all.first
  movie = movies.all[0]
  movie = movies.filter(title: 'Terminator')
```

  # get the number of well-known actors, who played in the film

```sh
  movie.actors.count
```

  # does the actor plays in the film

```sh
  movie.actors.include?('Arnold Shwarzenegger')
```

  # to know whether the film belongs to the genre

```sh
  movies.first.has_genre?('Camedy')
```

  # to know the film's budget

```sh
  movie = movies.all[112]
  movie.budget
```

  # get a poster for the film

```sh
  movie = movies.filter(title: 'Terminator')
  movie.poster
```

  # receive translations of the film in other language

```sh
  movie = movies.filter(title: '12 Angry Men')
  movie.translations
```

####HTML

  # create HTML markup

```sh
  movies.render_html
```

Author
--------------
Serhii Dmytrakov <clamdm@mail.ru>