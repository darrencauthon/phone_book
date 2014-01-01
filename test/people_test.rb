gem 'minitest', '~> 5.0'
require 'csv'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require './lib/person'
require './lib/people'
require 'mocha/setup'

describe People do

  [:first_name, :last_name].each do |property|

    describe "find_by_#{property}" do

      let(:people) { People.new(nil) }

      before do
        records = [Person.new(property => 'a'),
                   Person.new(property => 'c'),
                   Person.new(property => 'c'),
                   Person.new(property => 'd')]
        people.stubs(:all).returns records
      end

      ['a', 'd'].each do |example|

        describe "single match for #{example}" do
          it "should return the single result" do
            results = people.send("find_by_#{property}".to_sym, example)
            results.count.must_equal 1
            results.first.send(property).must_equal example
          end
        end

      end

      describe "multiple matches" do
        it "should return the multiple matches" do
          results = people.send("find_by_#{property}".to_sym, 'c')
          results.count.must_equal 2
          results.each { |r| r.send(property).must_equal 'c' }
        end
      end

      ['c', 'C'].each do |search_term|

        describe "case insensitive matches" do

          before do
            records = [Person.new(property => 'c'),
                       Person.new(property => 'C')]
            people.stubs(:all).returns records
          end

          it "should return multiple matches" do
            results = people.send("find_by_#{property}".to_sym, search_term)
            results.count.must_equal 2
          end

        end

      end

      describe "searching against nil fields" do

        before do
          records = [Person.new(property => 'z'),
                     Person.new(property => nil)]
          people.stubs(:all).returns records
        end

        it "should be ignored" do
          results = people.send("find_by_#{property}".to_sym, 'z')
          results.count.must_equal 1
          results.first.send(property).must_equal 'z'
        end

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
