garb
    by Tony Pitale & Justin Marney
    http://github.com/vigetlabs/garb

== DESCRIPTION:

Provides a Ruby API to the Google Analytics API.

== BASIC USAGE:

  session = Garb::Session.new(email, password)  # new default session
  session.get_auth_token                        # get the authentication token to be used
  account = Garb::Account.new(session)          # access the account profiles for this session email
  profiles = account.all                        # get the profile list
  
  # create a new report that gets pageviews for each browser
  report = Garb::Report.new(profiles.first, session, :metrics => [:pageviews], :dimensions => [:browser], :sort => [:browser])
  entries = report.all  # get the complete list
  entries.first         # e.g., ['1200', 'Firefox']
  
  ****************************************************
  You could also create the report like this:
  
  report = Garb::Report.new(profiles.first, session) do |r|
    r.metrics = [:pageviews]
    r.dimensions << :browser
    r.sort = [:browser]
  end
  
  If you want to set the sort to be descending you must do this:
  
  r.sort = '-ga:browser' # the minus is used to denote descending order
  
  You could set all of your metrics, dimensions, and sort with strings. Symbols are prefixed with 'ga'

== REQUIREMENTS:

net/http
ratom

== INSTALL:

sudo gem install garb -s http://gems.github.com

== TODO:

Key entries by property name #=> {:pageviews => '120', :browser => 'Firefox'}
or create a structure that has accessors for each of the metrics and dimensions

Sorting in reverse order
Detect if sort params are not in dimensions or metrics

Filtering

== LICENSE:

(The MIT License)

Copyright (c) 2008 Viget Labs (different license?)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
