#!/usr/bin/ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'

browser= Watir::Browser.new
puts "creating a new Watir browser"
i =0
while i < 9 do
  browser.goto 'http://www.axs.com'
  browser.link(:class => "events_link", :index => i).when_present.click
  if browser.div(:class => "column-secondary").exists? 
    #print out the stuff
    event_id = browser.input(:id=> "event_id").value
    j= 0 
#while browser.link(:class => "btn-size-small",  :index => j).exists? do 
     
    while browser.div(:class => "call-to-action",  :index => j).exists? do 
        text = browser.link(:class => "btn-size-small", :index => j).text
        puts "Purchase button " + j.to_s + " for event " + event_id.to_s + ": " + text
        j+=1
    end
  end
  puts "\n"
  i += 3
end

browser.goto 'http://www.axs.com'
#text = browser.link(:class => "events_link", :index => i).html
#puts text
browser.link(:class => "events_link", :index => 20).when_present.click
if browser.div(:class => "column-secondary").exists? 
  #print out the stuff
  event_id = browser.input(:id=> "event_id").value
  j = 0;
  while browser.div(:class => "call-to-action",  :index => j).exists? do 
    text = browser.link(:class => "btn-size-small", :index => j).text
    puts "Purchase button " + j.to_s + " for event " + event_id.to_s + ": " + text
    j += 1
    end
  end
end

browser.close
