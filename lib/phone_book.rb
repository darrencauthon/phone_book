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
    the_people  = people.find_by_last_name name
    the_numbers = numbers.find_by_person_id the_people.first.id
    [Entry.new(the_people.first, the_numbers)]
  end

  def terms(name)
    name.match(/([^,]*),?\ ?(.+)?/).to_a[1..-1]
  end

  def reverse_lookup(number)
    Entry.new(Person.new(first_name: 'Marisa', last_name: 'Kessler'), ["(857) 229-4967", "(378) 724-7986"])
  end
end
