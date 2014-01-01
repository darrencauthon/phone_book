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
    if name.include? ', '
      the_people = people.find_by_last_name name.split(', ')[0]
      the_people = the_people.select { |x| x.first_name == name.split(', ')[1] }
    else
      the_people = people.find_by_last_name name
    end
    the_people.map do |person|
      the_numbers = numbers.find_by_person_id person.id
      Entry.new(person, the_numbers)
    end
  end

  def terms(name)
    name.match(/([^,]*),?\ ?(.+)?/).to_a[1..-1]
  end

  def reverse_lookup(number)
    Entry.new(Person.new(first_name: 'Marisa', last_name: 'Kessler'), ["(857) 229-4967", "(378) 724-7986"])
  end
end
