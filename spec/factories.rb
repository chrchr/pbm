Factory.define :location do |l|
  l.name 'Test Location Name'
  l.street '123 Pine'
  l.city 'Portland'
  l.state 'OR'
  l.zip '97211'
  l.lat 45.5589
  l.lon -122.645
  l.association :region, :name => 'portland'
end

Factory.define :machine do |m|
  m.name 'Test Machine Name'
end

Factory.define :location_machine_xref do |lmx|
  lmx.association :location
  lmx.association :machine
end

Factory.define :zone do |z|
  z.name 'Test Zone'
end

Factory.define :region do |r|
  r.name 'Test Region'
end

Factory.define :machine_score_xref do |msx|
end

Factory.define :event do |e|
  e.name 'Test Event'
end
