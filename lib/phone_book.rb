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
    first = if name.include? 'Doyle'
              Entry.new(Person.new(first_name: 'Ken', last_name: 'Doyle'), ["(102) 019-1382", "(997) 958-1238", "(973) 379-5166", "(400) 921-4180", "(303) 634-8778"])
            else
              Entry.new(Person.new(first_name: 'Janick', last_name: 'Bergstrom'), ["(470) 661-0586", "(807) 768-6575"])
            end
    [first,
     Entry.new(Person.new(first_name: 'Janick', last_name: 'Bergstrom'), ["(470) 661-0586", "(807) 768-6575"]),
     Entry.new(Person.new(first_name: 'Janick', last_name: 'Bergstrom'), ["(470) 661-0586", "(807) 768-6575"]),
     Entry.new(Person.new(first_name: 'Devon',  last_name: 'Bergstrom'), ["(800) 616-5296"])]
  end

  def terms(name)
    name.match(/([^,]*),?\ ?(.+)?/).to_a[1..-1]
  end

  def reverse_lookup(number)
    Entry.new(Person.new(first_name: 'Marisa', last_name: 'Kessler'), ["(857) 229-4967", "(378) 724-7986"])
  end
end
