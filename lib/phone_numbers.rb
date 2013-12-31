class PhoneNumbers
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def all
    @all ||= build_numbers
  end

  def find_by_person_id(id)
    find_by(:person_id, id)
  end

  def find_by_number(s)
    find_by(:to_s, s).first
  end

  private

  def find_by(attribute, value)
    all.select do |number|
      number.send(attribute) == value
    end
  end

  def build_numbers
    data.map do |row|
      PhoneNumber.new(row)
    end
  end

  def data
    CSV.open(filename, headers: true, header_converters: :symbol)
  end
end
