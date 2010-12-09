module Garb
  module Management
    class Segment
      attr_accessor :session, :path
      attr_accessor :id, :name, :definition

      def self.all(session = Session)
        feed = Feed.new(session, '/segments')
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.new_from_entry(entry, session)
        segment = new
        segment.session = session
        segment.path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        segment.properties = entry['dxp:segment']
        segment
      end

      def properties=(properties)
        self.id = properties['id']
        self.name = properties['name']
        self.definition = properties['dxp:definition']
      end
    end
  end
end
