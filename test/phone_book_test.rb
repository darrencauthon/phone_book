gem 'minitest', '~> 5.0'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require './lib/phone_book'

describe PhoneBook do

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
