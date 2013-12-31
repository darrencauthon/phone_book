gem 'minitest', '~> 5.0'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/person'
require './lib/people'

class PeopleTest < Minitest::Test
  def filename
    @filename ||= File.absolute_path("../fixtures/people.csv", __FILE__)
  end

  attr_reader :people
  def setup
    @people = People.new(filename)
  end

  def test_filename
    assert_equal filename, people.filename
  end

  def test_load_data
    person = people.all[247]
    assert_equal 248, person.id
    assert_equal "Lauryn Nienow", person.name
  end

  def test_find_by_first_name
    imeldas = people.find_by_first_name("Imelda")
    assert_equal 4, imeldas.size
    last_names = imeldas.map do |person|
      person.last_name
    end
    assert_equal ["Hane", "Heidenreich", "Schowalter", "Wilkinson"], last_names.sort
  end

  def test_find_by_last_name
    rices = people.find_by_last_name("Rice")
    assert_equal 3, rices.size
    first_names = rices.map do |person|
      person.first_name
    end
    expected = ["Elnora", "Jamal", "Maye"]
    assert_equal expected, first_names.sort
  end

  def test_find_by_id
    person = people.find_by_id(115)
    assert_equal 115, person.id
    assert_equal "Edd Schowalter", person.name
  end
end
