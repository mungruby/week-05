# 
# Here is where you will write the class Quotes
# 
# For more information about classes I encourage you to review the following:
# 
# @see http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Classes
# @see Programming Ruby, Chapter 3
# 
# 
# For this exercise see if you can employ the following techniques:
# 
# Use class convenience methods: attr_reader; attr_writer; and attr_accessor.
# 
# Try using alias_method to reduce redundancy.
# 
# @see http://rubydoc.info/stdlib/core/1.9.2/Module#alias_method-instance_method
# 
class Quotes

  DEFAULT_QUOTE = "Could not find a quote at this time"

  class << self
    attr_accessor :missing_quote
  end

  self.missing_quote = DEFAULT_QUOTE

  def self.load file
    Quotes.new(file: file)
  end


  attr_reader :file, :quotes
 
  alias_method  :all,  :quotes
  
  def initialize parms
    @file = parms[:file]
    @quotes = all_quotes @file
  end
  
  def find index
    @quotes.empty? ? Quotes.missing_quote : (0...quotes.size).include?(index) ? @quotes[index] : quotes.sample
  end

  alias_method  :[], :find

  def search parms = {} 
    results = parms.map {|criterion| @quotes.grep( create_regexp(*criterion) )}.flatten
    results.empty? ? @quotes : results
  end
  
  
  private
  
  #
  # @param [String] filename the name of the file to load all the quotes.
  #
  # @return [Array<String>] all the quotes found in the file.
  #
  def all_quotes(filename)
    if File.exists? filename
      File.readlines(filename).map {|quote| quote.strip }
    else
      []
    end
  end

  def create_regexp criterion, text
    case criterion
      when :start_with then %r(^#{text})
      when :end_with   then %r(#{text}$)
      when :include    then %r(#{text})
    end
  end
end
