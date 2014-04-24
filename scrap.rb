#!/usr/bin/ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'set'

class User
  @followed_events = Set.new
  def initialize(fname, lname, zip, email, password)
    @fname = fname
    @lname = lname
    @zip = zip
    @email = email
    @password = password
  end
  def initialize()
    @fname= (0...8).map{(65+ rand(26)).chr}.join
    @lname= @fname 
    @zip= (0..4).map{rand(9)}.join
    @email = rand_name + '@' + rand_name + '.com'
    @password = (0...8).map{(65+ rand(26)).chr}.join
  end
  def create_account (fname, lname, zip, email, password)
    browser.goto 'http://www.axs.com'
    until browser.div(:id => "nav-global-menu-container").exists? do
      sleep 1 
    end
    browser.link(:id => "global-menu-trigger").when_present.click
    puts "just clicked on the global menu bars"

    browser.link(:class => "myaxs-create-trigger omniture-my-axs").when_present.click
    puts "just clicked on create an account"

    puts "creating a random account"

    browser.text_field(:name => "axs_fname").set fname 
    browser.text_field(:name => "axs_lname").set lname 

    browser.text_field(:name => "axs_zip").set zip 

    browser.text_field(:name => "axs_email").set email
    browser.text_field(:name => "axs_email2").set email

    browser.text_field(:name => "axs_pass").set password
    browser.text_field(:name => "axs_pass2").set password

    browser.button(:class => "next-button").click
  end
  def global_search(search_string)
    puts "searching for #search_string"
    until browser.div(:id => "global-search-container").exists? do
      sleep 1
    end
    search = search_string + "\n"
    browser.text_field(:name => "q").set search
  end
  def follow_event(index)
    puts "following #index event"
    followed_link = browser.link(:class => "headliner", :index => index).text
    @followed_events.add("followed_link")
    puts followed_link
    browser.link(:class => "headliner", :index => index).click
    browser.link(:title => "Click to follow").when_present.click
  end

end

browser= Watir::Browser.new
puts "creating a new Watir browser"

browser.goto 'http://www.axs.com'

#until browser.div(:id => "nav-global-menu-container").exists? do
#  sleep 1
#end

browser.link(:id => "global-menu-trigger").when_present.click
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
followed_link = browser.link(:class => "headliner", :index => 1).text
puts followed_link
browser.link(:class => "headliner", :index => 1).click
browser.link(:title => "Click to follow").when_present.click
puts "sleeping to allow followed link to propogate through system"
sleep 2 
#verify the event is listed on the page
puts "checking if event was followed"
browser.goto 'http://www.axs.com/me/alerts'
if browser.link(:class => "headliner").text == followed_link 
  puts "Event was successfully followed"
  puts "TEST PASS"
else
  puts "Event was not successfully followed"
  puts "TEST FAIL"
end

browser.close

