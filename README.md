garb
====

  by Tony Pitale and Justin Marney

  http://github.com/vigetlabs/garb

Description
-----------

  Provides a Ruby API to the Google Analytics API.

  http://code.google.com/apis/analytics/docs/gdata/gdataDeveloperGuide.html

Basic Usage
===========

Login
-----
  
    > Garb::Session.login(username, password)

Profiles
--------

    > Garb::Profile.all
    > profile = Garb::Profile.all.first

Define a Report Class
---------------------

    class ExitsReport < Garb::Report
      def initialize(profile)
        super(profile) do |config|
          config.start_date = Time.now.at_beginning_of_month
          config.end_date = Time.now.at_end_of_month
          config.metrics << [:exits, :pageviews, :exit_rate]
          config.dimensions << :request_uri
          config.sort << :exits.desc
          config.max_results = 10
        end
      end
    end

Parameters
----------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * max_results: The maximum number of results to be returned

Metrics & Dimensions
--------------------

  Metrics and Dimensions are very complex because of the ways in which the can and cannot be combined.

  I suggest reading the google documentation to familiarize yourself with this.

  http://code.google.com/apis/analytics/docs/gdata/gdataReferenceDimensionsMetrics.html#bounceRate

  When you've returned, you can pass the appropriate combinations (up to 50 metrics and 2 dimenstions)
  to garb, as an array, of symbols. Or you can simply push a symbol into the array.

Sorting
-------

  Sorting can be done on any metric or dimension defined in the request, with .desc reversing the sort.
  
Building a Report
-----------------

  Given the class, session, and profile from above:

    reports = ExitsReport.new(profile).all

  reports will be an array of OpenStructs with methods for the metrics and dimensions returned.

Build a One-Off Report
----------------------

    report = Garb::Report.new(profile)
    report.metrics << :pageviews
    report.dimensions << :request_uri

    report.all

Filtering
---------

  Google Analytics supports a significant number of filtering options.

  http://code.google.com/apis/analytics/docs/gdata/gdataReference.html#filtering

  We handle filtering as an array of hashes that you can push into, 
  which will be joined together (AND'd)

  Here is what we can do currently:
  (the operator is a method on a symbol metric or dimension)

  Operators on metrics:

    :eql => '==',
    :not_eql => '!=',
    :gt => '>',
    :gte => '>=',
    :lt => '<',
    :lte => '<='

  Operators on dimensions:

    :matches => '==',
    :does_not_match => '!=',
    :contains => '=~',
    :does_not_contain => '!~',
    :substring => '=@',
    :not_substring => '!@'
    
  Given the previous example one-off report, we can add a line for filter:
  
    report.filters << {:request_uri.eql => '/extend/effectively-using-git-with-subversion/'}

TODOS
-----

  * Sessions are currently global, which isn't awesome
  * Single user login is the only supported method currently.
    Intend to add hooks for using OAuth
  * Intend to make defined report classes before more like AR
  * Support start-index
  * Read opensearch header in results
  * OR joining filter parameters

Requirements
------------

  happymapper

Install
-------

    sudo gem install garb -s http://gems.github.com

License
-------

  (The MIT License)

  Copyright (c) 2008 Viget Labs

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
