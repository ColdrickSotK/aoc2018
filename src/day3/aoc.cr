require "file"

module Day3
  def load(path : String)
    return File.open(path) do |file|
      file.gets_to_end.strip.split("\n")
    end
  end

  def build_grid(data : Array)
    coords = {} of Array(Int32) => Array(String)

    data.each do |claim|
      id, content = claim.split(" @ ")
      origin, size = content.split(": ")
      x, y = origin.split(",").map do |val|
        val.to_i - 1
      end
      dx, dy = size.split("x").map do |val|
        val.to_i - 1
      end

      Range.new(x, x+dx).each do |x_coord|
        Range.new(y, y+dy).each do |y_coord|
          if coords.has_key?([x_coord, y_coord])
            coords[[x_coord, y_coord]] << id
          else
            coords[[x_coord, y_coord]] = [id]
          end
        end
      end
    end
    return coords
  end

  def part1(data : Array)
    grid = build_grid data
    contested = grid.select() do |coord, ids|
      ids.size > 1
    end
    return contested.size
  end

  def part2(data : Array)
    grid = build_grid data
    uncontested = [] of String
    contested = [] of String
    grid.each do |coord, ids|
      if ids.size == 1 && !contested.includes?(ids[0])
        uncontested << ids[0]
        uncontested.uniq!
      elsif ids.size > 1
        ids.each do |id|
          uncontested.delete(id)
          contested << id
          contested.uniq!
        end
      end
    end
    return uncontested[0]
  end
end

include Day3

data = load(ARGV[0])
puts part1 data
puts part2 data
