#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'rubygems'
require 'twitter'

require File.join(File.dirname(__FILE__), 'account')


# retrieve account information.
account = AccountManager::Account.new("#{ENV['HOME']}/.retweeter")

# when no information available, ask a user to input information.
if ! account.user
  account.interactive_input
end
account.update


# authentication
httpauth = Twitter::HTTPAuth.new(account.user, account.password, {:ssl => true})
base = Twitter::Base.new(httpauth)
# connetct to twitter
client = Twitter::Base.new(base)

# process each mentions
if ! (account.since_id == nil || account.since_id == "")
  mentions = client.mentions({:since_id => "#{account.since_id}"})
else
  mentions = client.mentions
end

if mentions != nil
  mentions.reverse_each {|tweet|
#     ### for debug begin
#     print "------------------------------\n"
#     print "ID  : #{tweet.id}\n"
#     print "From: #{tweet.user.screen_name}\n"
#     print "Text: #{tweet.text}\n"
#     ### debug end
     client.retweet(tweet.id)
    account.since_id = "#{tweet.id}"
  }
end

account.update