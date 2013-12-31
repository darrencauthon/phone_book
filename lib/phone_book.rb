require 'csv'
require_relative 'entry'
require_relative 'people'
require_relative 'person'
require_relative 'phone_number'
require_relative 'phone_numbers'

class PhoneBook
  attr_reader :people, :numbers

  def initialize(people, numbers)
    @people = people
    @numbers = numbers
  end

  def lookup(name)
    last_name, first_name = terms(name)

    results = people.find_by_last_name(last_name)
    if first_name
      results = results.select { |person| person.first_name == first_name }
    end
    results.map do |person|
      Entry.new(person, numbers.find_by_person_id(person.id))
    end
  end

  def terms(name)
    name.match(/([^,]*),?\ ?(.+)?/).to_a[1..-1]
  end

  def reverse_lookup(number)
    id = numbers.find_by_number(number).person_id
    Entry.new(people.find_by_id(id), numbers.find_by_person_id(id))
  end
end
