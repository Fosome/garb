Garb
====

  http://github.com/vigetlabs/garb

Important Changes
=================

 Please read CHANGELOG

Description
-----------

  Provides a Ruby API to the Google Analytics API.

  http://code.google.com/apis/analytics/docs/gdata/gdataDeveloperGuide.html

Basic Usage
===========

Single User Login
-----------------
  
    > Garb::Session.login(username, password)
    
OAuth Access Token
------------------

    > Garb::Session.access_token = access_token # assign from oauth gem

Accounts
--------

    > Garb::Account.all

Profiles
--------

    > Garb::Account.first.profiles
    
    > Garb::Profile.first('UA-XXXX-XX')
    
    > Garb::Profile.all
    > profile = Garb::Profile.all.first

Define a Report Class
---------------------

    class Exits
      extend Garb::Resource

      metrics :exits, :pageviews, :exit_rate
      dimensions :page_path
      sort :exits

      filters do
        eql(:page_path, 'season')
      end

      # alternative:
      # filters :page_path.eql => 10
    end

Get the Results
---------------

    > Exits.results(profile)

  OR shorthand

    > profile.exits

Other Parameters
----------------

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
      sort :exits

      filters do
        contains(:page_path, 'season')
        gt(:exits, 100)
      end

      # or with a hash
      # filters :page_path.contains => 'season', :exits.gt => 100
    end

  reports will be an array of OpenStructs with methods for the metrics and dimensions returned.

Build a One-Off Report
----------------------

    report = Garb::Report.new(profile)
    report.metrics :pageviews, :exits
    report.dimensions :page_path
    report.sort :exits

    report.filters do
      contains(:page_path, 'season')
      gte(:exits, 10)
    and

    # or with a hash
    # report.filters :page_path.contains => 'season', :exits.gt => 100

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

    eql => '==',
    not_eql => '!=',
    gt => '>',
    gte => '>=',
    lt => '<',
    lte => '<='

  Operators on dimensions:

    matches => '==',
    does_not_match => '!=',
    contains => '=~',
    does_not_contain => '!~',
    substring => '=@',
    not_substring => '!@'
    
  Given the previous example one-off report, we can add a line for filter:
  
    report.filters do
      eql(:page_path, '/extend/effectively-using-git-with-subversion/')
    end

  Or, if you're comfortable using symbol operators:

    report.filters :page_path.eql => '/extend/effectively-using-git-with-subversion/'

SSL
---

  Version 0.2.3 includes support for real ssl encryption for SINGLE USER authentication. First do:

    Garb::Session.login(username, password, :secure => true)

  Next, be sure to download http://curl.haxx.se/ca/cacert.pem into your application somewhere.
  Then, define a constant CA_CERT_FILE and point to that file.

  For whatever reason, simply creating a new certificate store and setting the defaults would
  not validate the google ssl certificate as authentic.

TODOS
-----

  * Read opensearch header in results
  * Investigate new features from GA to see if they're in the API, implement if so
  * clarify AND/OR filtering behavior in code and documentation

Requirements
------------

  * crack >= 0.1.6
  * active_support >= 2.2.0

Requirements for Testing
------------------------

  * jferris-mocha
  * tpitale-shoulda (works with minitest)

Install
-------

    sudo gem install garb

Contributors
------------

  Many Thanks, for all their help, goes to:

  * Patrick Reagan
  * Justin Marney
  * Nick Plante

License
-------

  (The MIT License)

  Copyright (c) 2010 Viget Labs

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
