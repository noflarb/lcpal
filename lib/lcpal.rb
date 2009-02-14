require 'hpricot'
require 'dm-core'
require 'lib/lcpa_adapter'
require 'lib/person'
require 'lib/parcel'

DataMapper::Logger.new(STDOUT, 0)
DataMapper.setup(:lcpa, :database => 'http://www.leonpa.org/search2.cfm', :adapter => 'lcpa')

module LCPAL
end