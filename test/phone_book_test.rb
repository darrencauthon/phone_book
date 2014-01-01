gem 'minitest', '~> 5.0'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require './lib/phone_book'
require 'mocha/setup'

describe PhoneBook do

  describe "lookup" do

    let(:people)  { Object.new }
    let(:numbers) { Object.new }

    let(:phone_book) { PhoneBook.new people, numbers }

    [ { last_name: 'x', person_id: 3, phone_numbers: '1' },
      { last_name: 'y', person_id: 4, phone_numbers: '2' }].each do |example|

      describe "one record exists by last name" do

        let(:last_name)   { example[:last_name] }
        let(:the_persons) { [Person.new(id: example[:person_id])] }
        let(:the_numbers) { example[:phone_numbers] }

        before do
          people.stubs(:find_by_last_name).with(last_name).returns the_persons
          numbers.stubs(:find_by_person_id).with(example[:person_id]).returns the_numbers
        end

        it "should return one entry" do
          results = phone_book.lookup last_name
          results.count.must_equal 1
          results[0].class.must_equal Entry
        end

        it "should return the person" do
          result = phone_book.lookup(last_name).first
          result.person.must_be_same_as the_persons.first
        end

        it "should return the numbers" do
          result = phone_book.lookup(last_name).first
          result.numbers.must_equal [the_numbers]
        end

      end

    end

    describe "multiple record exists by last name" do

      let(:last_name) { 'x' }

      let(:the_persons) do
        [Person.new(id: 1),
         Person.new(id: 2)]
      end

      before do
        people.stubs(:find_by_last_name).with(last_name).returns the_persons
        numbers.stubs(:find_by_person_id).with(1).returns 'p0'
        numbers.stubs(:find_by_person_id).with(2).returns 'p1'
      end

      it "should return two entries" do
        results = phone_book.lookup last_name
        results.count.must_equal 2
        results.select { |x| x.class == Entry }.count.must_equal 2
      end

      it "should return the first person" do
        result = phone_book.lookup(last_name)[0]
        result.person.must_be_same_as the_persons[0]
      end

      it "should return the second person" do
        result = phone_book.lookup(last_name)[1]
        result.person.must_be_same_as the_persons[1]
      end

      it "should return the phone numbers for the first person" do
        result = phone_book.lookup(last_name)[0]
        result.numbers.must_equal ['p0']
      end

      it "should return the phone numbers for the second person" do
        result = phone_book.lookup(last_name)[1]
        result.numbers.must_equal ['p1']
      end

    end

  end

  describe "concrete example with data files" do

    describe "first example" do

      let(:people) do
        People.new(File.absolute_path("../fixtures/people.csv", __FILE__))
      end

      let(:numbers) do
        PhoneNumbers.new(File.absolute_path("../fixtures/phone_numbers.csv", __FILE__))
      end

      let(:phone_book) do
        PhoneBook.new(people, numbers)
      end

      it "should return the bergstroms" do
        bergstroms = phone_book.lookup("Bergstrom")

        entry = bergstroms[0]
        assert_equal "Janick Bergstrom", entry.name
        assert_equal ["(470) 661-0586", "(807) 768-6575"], entry.phone_numbers

        entry = bergstroms[3]
        assert_equal "Devon Bergstrom", entry.name
        assert_equal ["(800) 616-5296"], entry.phone_numbers
      end

      it "should return the doyles" do
        entry = phone_book.lookup("Doyle, Ken").first
        assert_equal "Ken Doyle", entry.name
        expected = ["(102) 019-1382", "(997) 958-1238", "(973) 379-5166", "(400) 921-4180", "(303) 634-8778"]
        assert_equal expected, entry.phone_numbers
      end

      it "should reverse lookup marisa kessler" do
        entry = phone_book.reverse_lookup("(378) 724-7986")
        assert_equal "Marisa Kessler", entry.name
        assert_equal ["(857) 229-4967", "(378) 724-7986"], entry.phone_numbers
      end

    end

  end

end
