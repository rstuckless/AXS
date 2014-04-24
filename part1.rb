#!/usr/bin/ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'set'

class User
  $followed_events = Set.new
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
    @email = @fname + '@' + @lname + '.com'
    @password = (0...8).map{(65+ rand(26)).chr}.join
  end
  def create_account(browser)
    browser.goto 'http://www.axs.com'
    until browser.div(:id => "nav-global-menu-container").exists? do
      sleep 1 
    end
    browser.link(:id => "global-menu-trigger").when_present.click
    puts "just clicked on the global menu bars"

    browser.link(:class => "myaxs-create-trigger omniture-my-axs").when_present.click
    puts "just clicked on create an account"

    puts "creating a random account"

    browser.text_field(:name => "axs_fname").set @fname 
    browser.text_field(:name => "axs_lname").set @lname 

    browser.text_field(:name => "axs_zip").set @zip 

    browser.text_field(:name => "axs_email").set @email
    browser.text_field(:name => "axs_email2").set @email

    browser.text_field(:name => "axs_pass").set @password
    browser.text_field(:name => "axs_pass2").set @password

    browser.button(:class => "next-button").click
  end
  def global_search(browser, search_string)
    puts "searching for #search_string"
    until browser.div(:id => "global-search-container").exists? do
      sleep 1
    end
    search = search_string + "\n"
    browser.text_field(:name => "q").set search
  end
  def follow_event(browser)
    followed_link = browser.link(:class => "headliner", :index => 1).text
    $followed_events.add(followed_link)
    puts "following " + followed_link
    browser.link(:title => "Click to follow").when_present.click
  end
  def verify_followed(browser)
    browser.goto 'http://www.axs.com/me/alerts'
    i = 0
    while i<20 do
      while browser.link(:class => "headliner", :index => i).exists? do
        if @followed_events.include?(browser.link(:class => "headliner").text) 
          puts "Event was successfully followed"
          return true;
        else
          puts "event was not successfully followed"
          return false;
        end
      end
    end
  end
end

browser= Watir::Browser.new
puts "creating a new Watir browser"

#create new user
user1 = User.new()

#create a new user account
user1.create_account(browser)

#search for an event
user1.global_search(browser, "sports")

#click follow this event link
puts "navigating to first event"
browser.link(:class => "headliner", :index => 1).click
user1.follow_event(browser)

puts "sleeping to allow followed link to propogate through system"
sleep 2 

#verify the event is listed on the page
puts "checking if event was followed"
if user1.verify_followed(browser) == true
  puts "TEST PASS"
else
  puts "TEST FAIL"
end

browser.close
