require "file"

module Day2
  def load(path : String)
    return File.open(path) do |file|
      file.gets_to_end.strip.split("\n")
    end
  end

  def part1(data : Array)
    twos = 0
    threes = 0

    data.each do |id|
      two = false
      three = false

      id.chars.each do |char|
        if id.count(char) == 2 && !two
          twos += 1
          two = true
        elsif id.count(char) == 3 && !three
          threes += 1
          three = true
        end
      end
    end

    return twos * threes
  end

  def part2(data : Array)
    data.each do |id|
      data.each do |other|
        diff = 0
        diff_idx = 0
        id.chars.each_with_index do |char, idx|
          if other[idx] != char
            diff += 1
            diff_idx = idx
          end
        end
        if diff == 1
          return id[0..diff_idx-1] + id[diff_idx+1..-1]
        end
      end
    end
  end
end

include Day2

data = load(ARGV[0])
puts part1 data
puts part2 data
