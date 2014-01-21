require 'carrierwave'
require 'carrierwave-processing'

require 'spec_helper'

working_module_names = (RUBY_PLATFORM == 'java' ? %w[MiniMagick] : %w[RMagick MiniMagick])

working_module_names.each do |module_name|
  describe CarrierWave::Processing.const_get(module_name) do
    before do
      FileUtils.rm_rf(fixture_path('uploads'))
    end

    it 'strips image metadata' do
      uploader = uploader_for(module_name) {
        process :strip
      }

      expect(exif(fixture_path('little_foxes.jpg'), 'Artist')).not_to be_empty

      open_fixture 'little_foxes.jpg' do |file|
        uploader.store!(file)
      end

      expect(exif(uploader.store_path, 'Artist')).to be_empty
    end

    it 'reduces image quality' do
      uploader = uploader_for(module_name) {
        process :quality => 50
      }

      open_fixture 'little_foxes.jpg' do |file|
        uploader.store!(file)
      end

      expect(File.size(uploader.store_path)).to be < File.size(fixture_path('little_foxes.jpg'))
    end

    it 'changes image colorspace to CMYK' do
      uploader = uploader_for(module_name) {
        process :colorspace => :cmyk
      }

      expect(colorspace(fixture_path('little_foxes.jpg'))).to include('RGB')

      open_fixture 'little_foxes.jpg' do |file|
        uploader.store!(file)
      end

      expect(colorspace(uploader.store_path)).to eq('CMYK')
    end

    it 'changes image colorspace to sRGB' do
      uploader = uploader_for(module_name) {
        process :colorspace => :rgb
      }

      expect(colorspace(fixture_path('little_foxes_cmyk.jpg'))).to eq('CMYK')

      open_fixture 'little_foxes_cmyk.jpg' do |file|
        uploader.store!(file)
      end

      expect(colorspace(uploader.store_path)).to include('RGB')
    end

    it 'blurs image' do
      uploader = uploader_for(module_name) {
        process :blur => [5, 5]
      }

      open_fixture 'little_foxes.jpg' do |file|
        uploader.store!(file)
      end

      expect(File.size(uploader.store_path)).to be < File.size(fixture_path('little_foxes.jpg'))
    end
  end
end

describe CarrierWave::Processing do
  before do
    FileUtils.rm_rf(fixture_path('uploads'))
  end

  it 'produces the same transformations for all modules' do
    uploaders = working_module_names.map { |module_name|
      uploader_for(module_name) {
        process :strip
        process :quality => 90
        process :blur => [0, 2]
        process :colorspace => :cmyk
      }
    }

    uploaders.each do |uploader|
      open_fixture 'little_foxes.jpg' do |file|
        uploader.store!(file)
      end
    end

    files = uploaders.map { |uploader| File.open(uploader.store_path, 'rb', &:read) }
    expect(files).to be_all { |file| file == files[0] }
  end
end
