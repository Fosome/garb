module Garb
  module Management
    class Feed
      BASE_URL = "https://www.googleapis.com/analytics/v2.4/management"

      def initialize(session, path)
        @session = session
        @base_url = BASE_URL + path
      end

      def entries
        @entries ||= [].tap do |total_entries|
          parameters = {}

          # An edge exists where a user has more than 1000 GA Profiles.
          # Google will only return a max of 1000 profiles per request.
          # Therefor, we may have to make follow-up requests to get all the profiles.
          # This look will get all profiles, making the extra requests if needed.
          while true
            parsed_response = parsed_response(parameters)
            return total_entries unless parsed_response # return if there is no valid response

            # add this request's results to the previous set's
            total_entries = total_entries + [parsed_response['feed']['entry']].flatten.compact

            # attempt to get the next page link, this is the best way to tell if there are more results to get
            next_link = Garb.parse_link(parsed_response['feed'], 'next')
            return total_entries unless next_link # no more results, return the results we have

            next_link_parts = next_link.split('?') # split into a base URL and query parameters
            return total_entries if next_link_parts.size != 2

            # next_link_parts[0] is just @base_url again so ignore it
            # convert the query params to a hash so we can pass it to the next request object
            parameters = parameters_to_hash(next_link_parts[1])
          end
        end
      end

      def parsed_response(query_params = {})
        Crack::XML.parse(response(query_params).body)
      end

      def response(query_params = {})
        Garb::Request::Data.new(@session, @base_url, query_params).send_request
      end

      private
        def parameters_to_hash(parameters)
          {}.with_indifferent_access.tap do |param_hash|
            parameters.split('&').each do |element|
              element = element.split('=')
              param_hash[element[0]] = element[1]
            end
          end
        end
    end
  end
end
