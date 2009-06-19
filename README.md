garb
====

  by Tony Pitale with much help from Justin Marney, Patrick Reagan and others at Viget Labs

  http://github.com/vigetlabs/garb

Important Changes
=================

  Version 0.2.4 requires happymapper from rubygems, version 0.2.5. Be sure to update.

  Version 0.2.0 makes major changes (compared to 0.1.0) to the way garb is used to build reports.
  There is now both a module that gets included for generating defined classes,
  as well as, slight changes to the way that the Report class can be used.

Description
-----------

  Provides a Ruby API to the Google Analytics API.

  http://code.google.com/apis/analytics/docs/gdata/gdataDeveloperGuide.html

Basic Usage
===========

Login
-----
  
    > Garb::Session.login(username, password)

Accounts
--------
    > Garb::Account.all

Profiles
--------

    > Garb::Account.first.profiles
    
    > Garb::Profile.all
    > profile = Garb::Profile.all.first

Define a Report Class and Get Results
-------------------------------------

    class Exits
      include Garb::Resource

      metrics :exits, :pageviews, :exit_rate
      dimensions :request_uri
    end

Parameters
----------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * limit: The maximum number of results to be returned
  * offset: The starting index

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

  Given the class, session, and profile from above we can do:

    Exits.results(profile, :limit => 10, :offset => 19)

  Or, with sorting and filters:

    Exits.results(profile, :limit => 10, :offset => 19) do
      filter :request_uri.contains => 'season', :exits.gt => 100
      sort :exits
    end

  reports will be an array of OpenStructs with methods for the metrics and dimensions returned.

Build a One-Off Report
----------------------

    report = Garb::Report.new(profile)
    report.metrics :pageviews
    report.dimensions :request_uri

    report.filter :request_uri.contains => 'season', :exits.gte => 10
    report.sort :exits

    report.results

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

SSL
---

  Version 0.2.3 includes support for real ssl encryption for authentication. First do:

    Garb::Session.login(username, password, :secure => true)

  Next, be sure to download http://curl.haxx.se/ca/cacert.pem into your application somewhere.
  Then, define a constant CA_CERT_FILE and point to that file.

  For whatever reason, simply creating a new certificate store and setting the defaults would
  not validate the google ssl certificate as authentic.

TODOS
-----

  * Sessions are currently global, which isn't awesome
  * Single user login is the only supported method currently.
    Intend to add hooks for using OAuth
  * Read opensearch header in results
  * OR joining filter parameters

Requirements
------------

  happymapper >= 0.2.5 (should also install libxml)

Install
-------

    sudo gem install garb

    OR

    sudo gem install vigetlabs-garb -s http://gems.github.com

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
