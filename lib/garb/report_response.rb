module Garb  
  class ReportResponse
    KEYS = ['dxp:metric', 'dxp:dimension']

    def initialize(response_body, instance_klass = OpenStruct)
      @xml = response_body
      @instance_klass = instance_klass
    end

    def results
      @results ||= parse
    end

    private
    def parse
      entries.map do |entry|
        hash = values_for(entry).inject({}) do |h, v|
          h.merge(Garb.from_ga(v['name']) => v['value'])
        end

        @instance_klass.new(hash)
      end
    end

    def entries
      entry_hash = Crack::XML.parse(@xml)
      entry_hash ? [entry_hash['feed']['entry']].flatten.compact : []
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
