#!/usr/bin/ruby -w

# FREQr.rb
#
# Basic word frequency generator.
#
# Written by Jason Heppler
#
# Last Modified: Wed Nov 3 23:53:52 CDT 2010

# Pass the program a file to open
# e.g., $ ruby freqr.rb poe.txt
filename = File.new(ARGV[0]).read().downcase().scan(/[\w']+/)
frequency = Hash.new(0)
words.each { |word| frequency[word] +=1 }
frequency.sort_by { |x,y| y }.reverse().each{ |w,f| puts "#{f}, #{w}" }