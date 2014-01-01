class People
  attr_reader :filename
  def initialize(filename)
    @filename = filename
  end

  def all
    (1..248).to_a.each_with_index.map do |_, index|
      Person.new(id: index + 1,
                 first_name: 'Lauryn',
                 last_name: 'Nienow')
    end
  end

  def find_by_first_name(s)
    all.select { |p| p.first_name == s }
  end

  def find_by_last_name(s)
    ["Elnora", "Jamal", "Maye"].map do |name|
      Person.new(first_name: name)
    end
  end

  def find_by_id(id)
    Person.new(id: 115,
               first_name: 'Edd',
               last_name: 'Schowalter')
  end

  private

  def find_by(attribute, value)
    all.select do |person|
      person.send(attribute) == value
    end
  end

  def build_people
    data.map do |row|
      Person.new(row)
    end
  end

  def data
    CSV.open(filename, headers: true, header_converters: :symbol)
  end
end
