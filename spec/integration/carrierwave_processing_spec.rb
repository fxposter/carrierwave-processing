require 'carrierwave'
require 'carrierwave-processing'

require 'spec_helper'

[CarrierWave::Processing::RMagick, CarrierWave::Processing::MiniMagick].each do |mod|
  describe mod do
    let(:module_name) { subject.name.split('::').last }

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
  end
end
