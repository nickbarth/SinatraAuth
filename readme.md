# SinatraAuth

[![Build Status](https://secure.travis-ci.org/nickbarth/SinatraAuth.png?branch=master)](https://travis-ci.org/nickbarth/SinatraAuth)
[![Dependency Status](https://gemnasium.com/nickbarth/SinatraAuth.png)](https://gemnasium.com/nickbarth/SinatraAuth)

This is an example implementation of authentication in Sinatra.
It comes complete with integration, and unit tests using RSpec and Capybara, 
and uses ActiveRecord as an ORM.

My intention is that this code can be used, or built upon in your own Sinatra
applications. Feel free to contribute suggestions, fixes, and comments via pull
requests, or the issue tracker. :octocat:

## Usage

Here is how to use it.

### Install it

    git clone git@github.com:nickbarth/SinatraAuth.git
    cd SinatraAuth
    bundle

### Generate the database

    rake db:migrate

### And run it!
    $ thin start
    >> Using rack adapter
    >> Thin web server (v1.5.0 codename Knife)
    >> Maximum connections set to 1024
    >> Listening on 0.0.0.0:3000, CTRL+C to stop



### License

WTFPL &copy; 2012 Nick Barth
