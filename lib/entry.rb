class Entry
  attr_reader :person, :numbers

  def initialize(person, numbers)
    @person = person
    @numbers = Array(numbers)
  end

  def name
    person.name
  end

  def phone_numbers
    numbers.map(&:to_s)
  end
end

