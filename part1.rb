#!/usr/bin/ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'

browser= Watir::Browser.new
puts "creating a new Watir browser"

browser.goto 'http://www.axs.com'

until browser.div(:id => "nav-global-menu-container").exists? do
  sleep 1
end

browser.link(:id => "global-menu-trigger").click
puts "just clicked on the global menu bars"

browser.link(:class => "myaxs-create-trigger omniture-my-axs").when_present.click
puts "just clicked on create an account"

#create an account
puts "creating a random account"

rand_name = (0...8).map{(65+ rand(26)).chr}.join
browser.text_field(:name => "axs_fname").set rand_name
browser.text_field(:name => "axs_lname").set rand_name

rand_zip= (0..4).map{rand(9)}.join
browser.text_field(:name => "axs_zip").set rand_zip 


rand_email = rand_name + '@' + rand_name + '.com'
browser.text_field(:name => "axs_email").set rand_email
browser.text_field(:name => "axs_email2").set rand_email

rand_password = (0...8).map{(65+ rand(26)).chr}.join
browser.text_field(:name => "axs_pass").set rand_password
browser.text_field(:name => "axs_pass2").set rand_password

browser.button(:class => "next-button").click


#search for an event
puts "searching for sports"
until browser.div(:id => "global-search-container").exists? do
  sleep 1
end
search = "sports" + "\n"
browser.text_field(:name => "q").set search

#click follow this event link
puts "following first event"
browser.link(:title => "Click to follow").click
puts "sleeping to allow followed link to propogate through system"
sleep 2 
#verify the event is listed on the page
puts "checking if event was followed"
browser.goto 'http://www.axs.com/me/alerts'
if browser.link(:class => "event-image").exists? 
  puts "Event was successfully followed"
end

browser.close

puts "TEST PASS"
