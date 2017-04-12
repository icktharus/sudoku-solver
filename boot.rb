APP_ENV = ENV.fetch('ENV', 'development') unless defined?(APP_ENV)

require 'bundler'
Bundler.require(:default, APP_ENV)

Dir[File.dirname(__FILE__) + '/lib/sudoku/constraint/base.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/sudoku/constraint/unique_constraint.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/sudoku/constraint/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/sudoku/*.rb'].each {|file| require file }
