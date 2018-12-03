require "file"

def load(path : String)
  content = File.open(path) do |file|
    file.gets_to_end
  end
  return content.strip().split("\n").map do |val|
    val.to_i
  end
end

data = load(ARGV[0])
puts data.sum 0
