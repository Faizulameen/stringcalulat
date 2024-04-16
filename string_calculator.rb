class StringCalculator
  def add(numbers)
    return 0 if numbers.empty?

    delimiters = [",", "\n"]
    if numbers.start_with?("//")
      custom_delimiter, numbers = numbers.split("\n", 2)
      delimiters.push(custom_delimiter[2..-1])
    end

    numbers_arr = numbers.split(Regexp.union(delimiters))
    negatives = numbers_arr.select { |num| num.to_i.negative? }

    raise "negative numbers not allowed #{negatives.join(",")}" if negatives.any?

    numbers_arr.map(&:to_i).select { |num| num <= 1000 }.sum
  end
end

# Tests
require 'minitest/autorun'

class TestStringCalculator < Minitest::Test
  def setup
    @calc = StringCalculator.new
  end

  def test_empty_string
    assert_equal 0, @calc.add("")
  end

  def test_single_number
    assert_equal 1, @calc.add("1")
  end

  def test_two_numbers
    assert_equal 3, @calc.add("1,2")
  end

  def test_unknown_amount_of_numbers
    assert_equal 15, @calc.add("1,2,3,4,5")
  end

  def test_newline_as_separator
    assert_equal 6, @calc.add("1\n2,3")
  end

  def test_custom_delimiter
    assert_equal 3, @calc.add("//;\n1;2")
  end

  def test_negative_numbers
    assert_raises(RuntimeError) { @calc.add("-1,2,-3") }
  end

  def test_ignore_numbers_greater_than_1000
    assert_equal 2, @calc.add("1001,2")
  end
end
