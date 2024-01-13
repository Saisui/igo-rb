# encoding: UTF-8

module Igo
  module Zh
    def self.zh_convt( arr , str )
      convt_table = File.open(File.dirname(__FILE__) + "/zh_convt").read.split("\n&\n").map{ |group|
        group.split("\n").map{ |type|
          Hash[ type.split(',').map{ |term| term.split(':') } ]
        }
      }
      begin
        str0 = String.new( str )
        str1 = String.new( str )
        n = (str.size < 6)? str.size : 6
        convt_table.last(n).each do |group|
          arr.each do |t|
            group[t].each do |key , value|
              while !! q = str0.index( key )
                str0[q...(q + key.size)] = "#" * value.size
                str1[q...(q + key.size)] = value
              end
            end
          end
        end
        return str1
      rescue
        return "[#{$!}]"
      end
    end
    def self.to_cht( str )
      Zh.zh_convt( [0] , str )
    end

    def self.to_chs( str )
      Zh.zh_convt( [1] , str )
    end

    def self.to_tw( str )
      Zh.zh_convt( [2,0] , str )
    end

    def self.to_hk( str )
      Zh.zh_convt( [3,0] , str )
    end

    def self.to_cn( str )
      Zh.zh_convt( [4,1] , str )
    end
  end
end


module Igo

end
