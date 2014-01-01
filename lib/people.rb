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
    find_by(:first_name, s)
  end

  def find_by_last_name(s)
    find_by(:last_name, s)
  end

  def find_by_id(id)
    find_by(:id, id).first
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
