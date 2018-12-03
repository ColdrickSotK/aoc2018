require "file"

module Day1
  def load(path : String)
    content = File.open(path) do |file|
      file.gets_to_end
    end
    return content.strip().split("\n").map do |val|
      val.to_i
    end
  end

  def part1(data : Array)
    return data.sum 0
  end

  def part2(data : Array)
    seen = [] of Int32
    current = 0
    idx = 0
    found = false

    while true
      current += data[idx]
      if seen.includes? current
        return current
      else
        seen << current
      end
      idx += 1
      if idx >= data.size
        idx = 0
      end
    end
  end
end

include Day1

data = load(ARGV[0])
puts part1 data
puts part2 data
