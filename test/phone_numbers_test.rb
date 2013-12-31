gem 'minitest', '~> 5.0'
require 'csv'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/phone_number'
require './lib/phone_numbers'

class PhoneNumbersTest < Minitest::Test
  def filename
    @filename ||= File.absolute_path("../fixtures/phone_numbers.csv", __FILE__)
  end

  attr_reader :numbers
  def setup
    @numbers = PhoneNumbers.new(filename)
  end

  def test_filename
    assert_equal filename, numbers.filename
  end

  def test_load_data
    number = numbers.all[822]
    assert_equal 192, number.person_id
    assert_equal "(730) 377-4963", number.to_s
  end

  def test_find_by_person_id
    results = numbers.find_by_person_id(49)
    assert_equal 6, results.length
  end

  def test_find_by_number
    number = numbers.find_by_number("(390) 566-6424")
    assert_equal 294, number.person_id
    assert_equal "(390) 566-6424", number.to_s
  end
end
