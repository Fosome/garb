Version 0.7.4

  * Removes HappyMapper dependency in favor of Crack so we can drop libxml dependency

Version 0.7.0

  * Adds multi-session support

Version 0.6.0

  * Adds OAuth access token support
  * Simplifies Garb report access through a profile
  * Includes the start of a basic library of pre-built reports (require 'garb/reports')

Version 0.5.1
  
  * Brings back hash filters and symbol operators after agreed upon SymbolOperator

Version 0.5.0

  * Filters now have a new DSL so that I could toss Symbol operators (which conflict with DataMapper and MongoMapper)
  * The method of passing a hash to filters no longer works, at all

Version 0.4.0
  
  * Changes the api for filters and sort making it consistent with metrics/dimensions
  * If you wish to clear the defaults defined on a class, you may use clear_(filters/sort/metrics/dimensions)
  * To make a custom class using Garb::Resource, you must now extend instead of include the module

Version 0.3.2

  * adds Profile.first which can be used to get the first profile with a table id, or web property id (UA number)

Version 0.2.4

  * requires happymapper from rubygems, version 0.2.5. Be sure to update.

Version 0.2.0

  * makes major changes (compared to 0.1.0) to the way garb is used to build reports.
  * There is now both a module that gets included for generating defined classes,
  * slight changes to the way that the Report class can be used.
