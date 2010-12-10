Garb
====

  http://github.com/vigetlabs/garb

Important Changes
=================

  With The release of version 0.9.0 I have officially deprecated Garb::Report, Garb::Resource,
  Garb::Profile, and Garb::Account. Garb::Report and Garb::Resource should be replaced by Garb::Model.
  Garb::Profile and Garb::Account are supplanted by their Garb::Management::* counterparts.
  
  I'll be working hard to update the documentation over the next day or so to highlight all of the
  old features in the new classes, as well as any new features brought by the new classes. If you
  are looking for something in particular, please open an issue and I will try to prioritize these
  requests.

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

Accounts, WebProperties, Profiles, and Goals
--------

    > Garb::Management::Account.all
    > Garb::Management::WebProperty.all
    > Garb::Management::Profile.all
    > Garb::Management::Goal.all

Profiles for a UA- Number (a WebProperty)
--------

    > profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}

Define a Report Class
---------------------

    class Exits
      extend Garb::Model

      metrics :exits, :pageviews
      dimensions :page_path
    end

Get the Results
---------------

    > Exits.results(profile, :filters => {:page_path.eql => '/'})

  OR shorthand

    > profile.exits(:filters => {:page_path.eql => '/'})

  Be forewarned, these numbers are for the last **30** days and may be slightly different from the numbers displayed in Google Analytics' dashboard for **1 month**.

Other Parameters
----------------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * limit: The maximum number of results to be returned
  * offset: The starting index

Metrics & Dimensions
--------------------

  **Metrics and Dimensions are very complex because of the ways in which they can and cannot be combined.**

  I suggest reading the google documentation to familiarize yourself with this.

  http://code.google.com/apis/analytics/docs/gdata/gdataReferenceDimensionsMetrics.html#bounceRate

  When you've returned, you can pass the appropriate combinations to Garb, as symbols.

Filtering
---------

  Google Analytics supports a significant number of filtering options.

  http://code.google.com/apis/analytics/docs/gdata/gdataReference.html#filtering

  Here is what we can do currently:
  (the operator is a method on a symbol for the appropriate metric or dimension)

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
    
  Given the previous Exits example report in shorthand, we can add an option for filter:

    profile.exits(:filters => {:page_path.eql => '/extend/effectively-using-git-with-subversion/')

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

  * rebuild AND/OR filtering in Garb::Model

Requirements
------------

  * crack >= 0.1.6
  * active_support >= 2.2.0

Requirements for Testing
------------------------

  * shoulda
  * jferris-mocha

Install
-------

    gem install garb

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
