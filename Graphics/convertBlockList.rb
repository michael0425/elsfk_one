class Cube
  attr_reader :name, :value
  def initialize(name, data)
    @name = name
    count = data.size
    @value = []
    get_value(data, count)
  end
  def get_value(data, count)
    data.each do |c|
      @value << c
    end
  end
end
    

origin_file = 'Blocks.strings'
raw_data = 'RawData.txr'

f = File.new(raw_data,'w')
start = false
data = []
name = ''
cubes = []
File.new(origin_file).each do |line|
  line.chomp!
  if !start && line == 'START'
    start = true
  elsif start
    # set name
    if line =~ /n:(.*)/
      name = $1
    elsif line == ''
      cubes << Cube.new(name,data)
      data = []
      name = ''
    else
      data << line.split(',')
    end
  elsif start && line == 'END'
    start = false
  end
end

values = ''
names = ''
cubes.each do |cube|
  index = values.size
  names += "@\"#{cube.name}\",";
  
  values += "block = [[Block alloc] init];\n"
  cube.value.each do |xy|
    values += "[block loadCubeWithX:#{xy[0]} Y:#{xy[1]} color:RED type:SOLID];\n"
  end
  values += "[blockArray addObject:block];\n" +
            "[block release];\n\n"
end
names += 'nil'
puts "nameArray = [NSArray arrayWithObjects:#{names}];\n\n"
puts values
  
      
       
