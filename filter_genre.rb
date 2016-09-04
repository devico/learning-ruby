module TopMovies
  class FilterGenre

    attr_accessor :collect

    def initialize(collection)
      @collect = collection
    end

    def match?(filter_name, filter_value)
      value = if filter_value.is_a? Symbol
                send(filter_name).to_s[11..-1].to_sym
              else
                send(filter_name)
              end
      if value.is_a? Array
        value.any? do |v|
          filter_value.is_a?(Array) ? filter_value.include?(v) : v.include?(filter_value)
        end
      else
        # rubocop:disable CaseEquality
        filter_value === value
        # rubocop:enable CaseEquality
      end
    end

    def filter(filters)
      filters.reduce(@collect) do |filtered, (name, value)|
        filtered.select { |f| f.match?(name, value) }
      end
    end

  end
end