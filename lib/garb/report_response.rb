module Garb  
  class ReportResponse
    KEYS = ['dxp:metric', 'dxp:dimension']

    def initialize(response_body)
      @xml = response_body
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

        OpenStruct.new(hash)
      end
    end

    def entries
      entry_hash = Crack::XML.parse(@xml)
      entry_hash ? [entry_hash['feed']['entry']].flatten : []
    end

    def values_for(entry)
      KEYS.map {|k| entry[k]}.flatten.compact
    end
  end
end
