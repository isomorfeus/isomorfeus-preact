require 'spec_helper'
require 'oj'
require 'redux/version'

DATA_START_TEXT = 'window.chartData = '
DATA_END_TEXT = 'window.defaultSizes = "parsed";'
LIB_KEYS = ['isomorfeus-preact/ruby/lib', "isomorfeus-redux-#{Redux::VERSION}/lib"]

RSpec.describe 'Asset sizes' do
  def nested_hash_object(obj, key, value)
    if obj.respond_to?(:key?) && obj.key?(key) && obj[key].end_with?(value)
      obj
    elsif obj.respond_to?(:each)
      r = nil
      obj.find{ |*a| r=nested_hash_object(a.last,key, value) }
      r
    end
  end

  it 'are within limits' do
    report_html = File.read(File.join('public', 'assets', 'report.html'))

    data_start = report_html.index(DATA_START_TEXT) + DATA_START_TEXT.length
    data_end = report_html.index(DATA_END_TEXT) - 1
    data = report_html[data_start..data_end].tr(';', '')
    json = Oj.load(data)
    LIB_KEYS.each do |lib_key|
      obj = nested_hash_object(json, 'label', lib_key)
      stat_size = obj['statSize'] / 1024
      parsed_size = obj['parsedSize'] / 1024
      gzip_size = obj['gzipSize'] / 1024
      puts "Max asset sizes: #{lib_key}: stat: #{stat_size}kb, parsed: #{parsed_size}kb, gzip: #{gzip_size}kb"
      expect(stat_size < 352).to be true
      expect(parsed_size < 200).to be true
      expect(gzip_size < 30).to be true
    end
  end
end
