
puts
puts "list all output on a collection"
puts find_outputs('home', {},2).count
puts find_outputs('home', {})

puts "find_outputs"
puts find_outputs('home', "_id": "b3d6f737731842b2be198fc3a85283b7")
puts
puts "find_outputs not found"
puts find_outputs('home', "_id": "b3d6f737731842b2be198fc3a85283b7--").inspect
# puts nil['_collection']
puts
puts "find_output"
puts find_output('home',"_id": "b3d6f737731842b2be198fc3a85283b7")['_collection']
puts
puts "find_output not found"
puts find_output('home',"_id": "b3d6f737731842b2be198fc3a85283b7--").inspect
