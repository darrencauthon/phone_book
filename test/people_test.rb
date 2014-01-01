gem 'minitest', '~> 5.0'
require 'csv'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require './lib/person'
require './lib/people'
require 'mocha/setup'

describe People do

  describe "find_by_first_name" do

    let(:people) { People.new(nil) }

    before do
      records = [Person.new(first_name: 'a'),
                 Person.new(first_name: 'c'),
                 Person.new(first_name: 'c'),
                 Person.new(first_name: 'd')]
      people.stubs(:all).returns records
    end

    ['a', 'd'].each do |example|

      describe "single match for #{example}" do
        it "should return the single result" do
          results = people.find_by_first_name example
          results.count.must_equal 1
          results.first.first_name.must_equal example
        end
      end

    end
    
    describe "multiple matches" do
      it "should return the multiple matches" do
        results = people.find_by_first_name 'c'
        results.count.must_equal 2
        results.each { |r| r.first_name.must_equal 'c' }
      end
    end

  end

  describe "find_by_last_name" do

    let(:people) { People.new(nil) }

    before do
      records = [Person.new(first_name: 'x'),
                 Person.new(first_name: 'y'),
                 Person.new(first_name: 'y'),
                 Person.new(first_name: 'z')]
      people.stubs(:all).returns records
    end

    ['x', 'z'].each do |example|

      describe "single match for #{example}" do
        it "should return the single result" do
          results = people.find_by_first_name example
          results.count.must_equal 1
          results.first.first_name.must_equal example
        end
      end

    end
    
    describe "multiple matches" do
      it "should return the multiple matches" do
        results = people.find_by_first_name 'y'
        results.count.must_equal 2
        results.each { |r| r.first_name.must_equal 'y' }
      end
    end

  end

  describe "find_by_id" do

    [1, 2, 3, 4].each do |id|

      describe "it should return the record matching by id" do

        let(:people) { People.new(nil) }

        before do
          records = [Person.new(id: 1),
                     Person.new(id: 2),
                     Person.new(id: 3),
                     Person.new(id: 4)]
          people.stubs(:all).returns records
        end

        it "should return the appropriate record" do
          people.find_by_id(id).id.must_equal id
        end

      end

    end

  end

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
