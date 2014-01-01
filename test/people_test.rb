gem 'minitest', '~> 5.0'
require 'csv'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require './lib/person'
require './lib/people'

describe People do

  describe "importig people from a csv" do

    let(:filename) { File.absolute_path("../fixtures/people.csv", __FILE__) }

    let(:people) { People.new(filename) }

    it "should retain the filename" do
      people.filename.must_equal filename
    end

    it "should return the 247th record" do
      person = people.all[247]
      assert_equal 248, person.id
      person.id.must_equal 248
      person.name.must_equal "Lauryn Nienow"
    end

    it "should return the first names when finding by first name" do
      imeldas = people.find_by_first_name("Imelda")
      assert_equal 4, imeldas.size
      last_names = imeldas.map { |p| p.last_name }.sort
      last_names.must_equal ["Hane", "Heidenreich", "Schowalter", "Wilkinson"]
    end

    it "should return the last names when finding by last name" do
      rices = people.find_by_last_name("Rice")
      assert_equal 3, rices.size
      first_names = rices.map { |p| p.first_name }.sort
      first_names.must_equal ["Elnora", "Jamal", "Maye"] 
    end

    it "should return records by id" do
      person = people.find_by_id(115)
      person.id.must_equal 115
      person.name.must_equal "Edd Schowalter"
    end

  end

end
