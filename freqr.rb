#!/usr/bin/ruby -w
 
# FREQr.rb
#
# Written by Jason A. Heppler
#
# This program is free software.
# You can distribute/modify this program under the terms of
# the GNU Lesser General Public License version 2.1.
# 
# Last Modified: Mon Jan 10 23:15:08 CST 2011
 
require 'open-uri'
 
STOPWORDS = %w{a about above across after again against all am an and any are arent as at be because been before being below between both but by cant cannot could couldnt did didnt do does doesnt doing dont down during each few for form further had hadnt has hasnt have havent having he her here heres hers herself him himself his how i id ill im ive if in into is isnt it its itself lets me more most mustnt my myself my myself no nor not of off on once only or other ought our ours ourselves out over own same shant she should shouldnt so some such than that the their theirs them themselves then there these they this those through to too under until up very was we were what when where which while who why with would you your yours yourself yourselves}
 
# Tag Cloud class for generating a word cloud from a word frequency
class TagCloud
    attr_accessor :word_class
 
    def initialize(words)
        @wordcount = count_words(words)
    end
 
    def count_words(words)
        wordcount = {}
        words.each do |word|
            if word.strip.size > 0
                unless wordcount.key?(word.strip)
                    wordcount[word.strip] = 0
                else
                    wordcount[word.strip] = wordcount[word.strip] + 1
                end
            end
        end
        wordcount
    end
 
    def font_ratio(wordcount={})
        min, max = 100000, - 1000000
        wordcount.each_key do |word|
            max = wordcount[word] if wordcount[word] > max
            min = wordcount[word] if wordcount[word] < min
        end
        18.0 / (max - min)
    end
 
    def build
        cloud = String.new
        ratio = font_ratio(@wordcount)
        @wordcount.each_key do |word|
            font_size = (9 + (@wordcount[word] * ratio))
            cloud << %Q{<span#{" class=\"" + word_class + "\"" unless word_class.nil? } style="font-size:#{font_size}pt;">#{word}</span> }
 
        end
        cloud
    end
 
end
 
# Strip out HTML tags, alphanumeric characters, and punctuation, then 
# lower-case all words, split the words apart, and remove stopwords 
def readFile(url)
 
    uri_file = open(url).read.gsub(/<\/?[^>]*>/, "").gsub(/&quot;*/, "").gsub(/[0-9]*/, "").gsub(/[(,?!\'""':.)]/, '').downcase.split(' ') - STOPWORDS
 
    return uri_file
 
end
 
# Create a dictionary of n-grams
url = ARGV[0]
uri_file = readFile(url)
 
# Save output to HTML
File.open("output.html", "w") do |output|
        frequency = Hash.new(0)
        uri_file.each { |word| frequency[word] += 1 }
        frequency.sort_by { |x,y| y }.reverse().each do |w,f| 
            output.write "<p>#{f}, #{w}</p>\n"
    end
end
 
# Generate a word cloud and save as HTML
File.open("wordcloud.html", "w") do |output|
    cloud = TagCloud.new(uri_file)
    cloud.word_class = "freq-cloud-css"
    output.write cloud.build
end
 
# Give the user an exported-to message
puts "\nFile exported to #{Dir.pwd}.\n"

