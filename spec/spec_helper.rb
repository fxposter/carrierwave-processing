require 'fileutils'

module Helpers
  def fixture_path(filename)
    File.expand_path(File.join('..', 'fixtures', filename), __FILE__)
  end

  def open_fixture(filename, &block)
    File.open(fixture_path(filename), &block)
  end

  def exif(path, field)
    `identify -format %[exif:#{field}] #{path}`.chomp
  end

  def colorspace(path)
    `identify -verbose #{path} | grep 'Colorspace'`.chomp.split(':').last.strip
  end

  def uploader_for(module_name, &block)
    Class.new(CarrierWave::Uploader::Base) {
      include Helpers
      include CarrierWave.const_get(module_name)
      include CarrierWave::Processing.const_get(module_name)

      instance_eval(&block)

      define_method :store_dir do
        File.expand_path(File.join('..', 'uploads'), __FILE__)
      end

      define_method :filename do
        "#{module_name}#{File.extname(super())}" if original_filename.present?
      end
    }.new
  end
end

RSpec.configure do |config|
  config.include Helpers
end
