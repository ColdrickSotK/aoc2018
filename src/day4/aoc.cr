require "file"

module Day4
  def parse_time(timestamp : String)
    if matches = timestamp.match(/([0-9]*)-([0-9]*)-([0-9]*) ([0-9]*):([0-9]*)/)
      return Time.new(matches[1].to_i, matches[2].to_i, matches[3].to_i, matches[4].to_i, matches[5].to_i)
    end
    return Time.new(1510, 1, 1)
  end

  class LogMessage

    property timestamp : Time
    property message : String

    def initialize(raw : String)
      @raw = raw
      @timestamp = Time.new(1510, 1, 1)
      @message = ""
      if matches = raw.match(/\[(.*)\] (.*)/)
        @timestamp = parse_time(matches[1])
        @message = matches[2]
      end
    end
  end

  def load(path : String)
    return File.open(path) do |file|
      file.gets_to_end.strip.split("\n")
    end
  end

  def get_sleep_times(log : Array)
    guards = {} of String => Array(Int32)
    current_id = "none"
    sleep_start = 0
    sleep_end = 0
    log.each do |entry|
      # Get the ID of the guard currently on duty
      if m = entry.message.match(/Guard #([0-9]*) begins shift/)
        current_id = m[1]
      end
      if current_id == "none"
        next
      end

      if entry.message.match(/falls asleep/)
        sleep_start = entry.timestamp.minute
      end
      if entry.message.match(/wakes up/)
        sleep_end = entry.timestamp.minute
        if !guards.has_key?(current_id)
          guards[current_id] = [] of Int32
        end
        Range.new(sleep_start, sleep_end - 1).each do |i|
          guards[current_id] << i
        end
      end
    end
    return guards
  end

  def get_best_guard(guards : Hash)
    best = ""
    best_time = 0
    guards.each do |id, times|
      if times.size > best_time
        best_time = times.size
        best = id
      end
    end
    return best
  end

  def get_best_minute(times : Array)
    best = 0
    best_count = 0
    times.uniq.each do |time|
      count = times.count do |i|
        time == i
      end
      if count > best_count
        best_count = count
        best = time
      end
    end
    return best, best_count
  end

  def organise_log(data : Array)
    log = [] of LogMessage
    data.each do |message|
      log << LogMessage.new(message)
    end
    log.sort! do |a, b|
      a.timestamp <=> b.timestamp
    end
    return log
  end

  def part1(data : Array)
    log = organise_log(data)
    guards = get_sleep_times(log)
    best_id = get_best_guard(guards)
    best_minute, best_count = get_best_minute(guards[best_id])

    return best_id.to_i * best_minute
  end

  def part2(data : Array)
    log = organise_log(data)
    guards = get_sleep_times(log)

    best_id = 0
    best_min = 0
    best_count = 0
    guards.each do |id, times|
      min, count = get_best_minute(times)
      if count > best_count
        best_id = id
        best_min = min
        best_count = count
      end
    end
    return best_id.to_i * best_min

  end
end

include Day4

data = load(ARGV[0])
puts part1 data
puts part2 data
