module Garb
  module Management
    class Goal

      attr_accessor :session, :path
      attr_accessor :name, :number, :value, :destination, :active

      alias :active? :active

      def self.all(session = Session, path = '/accounts/~all/webproperties/~all/profiles/~all/goals')
        feed = Feed.new(session, path)
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.for_account(account)
        all(account.session, account.path + '/webproperties/~all/profiles/~all/goals')
      end

      def self.for_web_property(web_property)
        all(web_property.session, web_property.path + '/profiles/~all/goals')
      end

      def self.for_profile(profile)
        all(profile.session, profile.path + '/goals')
      end

      def self.new_from_entry(entry, session)
        goal = new
        goal.session = session
        goal.path = Garb.parse_link(entry, "self").gsub(Feed::BASE_URL, '')
        goal.properties = entry[Garb.to_ga('goal')]
        goal
      end

      def properties=(properties)
        self.name = properties["name"]
        self.number = properties["number"].to_i
        self.value = properties["value"].to_f
        self.active = (properties["active"] == "true")
        self.destination = Destination.new(properties[Garb.to_ga('destination')])
      end
    end
  end
end
