
$: << File.dirname(__FILE__)
require 'signal_parser'
use Rack::Static, :urls=>["/favicon.ico"]
run Sinatra::Application
