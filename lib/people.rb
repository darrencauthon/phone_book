class People
  attr_reader :filename
  def initialize(filename)
    @filename = filename
  end

  def all
    @all ||= build_people
  end

  def find_by_first_name(s)
    find_by(:first_name, s)
  end

  def find_by_last_name(s)
    find_by(:last_name, s)
  end

  def find_by_id(id)
    all.select { |x| x.id ==  id }.first
  end

  private

  def find_by(attribute, value)
    return [] if value.to_s == ''
    all.select do |person|
      person.send(attribute).to_s.downcase == value.downcase
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
