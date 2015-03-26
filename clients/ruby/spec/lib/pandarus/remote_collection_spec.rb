require 'spec_helper'

module Pandarus
  describe RemoteCollection do
    let(:footrest) {
      Footrest::Client.new({
        prefix: 'http://shard1.canvas.dev/api',
        token: "Bearer 1~A5dY8IsOyhVOVRJi4V3XWGNsa7pzuIbdM8OCv62YTRFqOsiS9vX0NbtY8PR9q4pX",
      })
    }
    let(:client) {
      footrest.connection
    }

    let(:path) { '/v1/courses/14/users' }
    let(:query_params) {
      {
        enrollment_type: 'student',
      }
    }
    let(:collection) {
      RemoteCollection.new(client, User, path, query_params)
    }

    describe '#first_page' do
      let(:page) {
        VCR.use_cassette('remote_collection_first_page') do
          collection.first_page
        end
      }

      before do
        query_params[:per_page] = 4
      end

      it 'must use the supplied query params' do
        expect(page.size).to eq 4
      end

      it 'must fetch the first page' do
        expect(page.all?{|member| User === member}).to be_truthy
      end
    end

    describe '#to_a' do
      it 'must gracefully handle an empty collection' do
        VCR.use_cassette('remote_collection_empty') do
          collection.instance_variable_set(:@path, '/v1/courses/183/users')
          array = collection.to_a
          expect(array).to be_empty
        end
      end

      it 'must happily fetch a collection with a single page' do
        VCR.use_cassette('remote_collection_single_page') do
          collection = RemoteCollection.new(client, Section, '/v1/courses/14/sections', {})
          array = collection.to_a
          expect(array.size).to eq 1
        end
      end

      it 'must fetch all pages of a multi page collection and combine them into a single array' do
        VCR.use_cassette('remote_collection_all_pages') do
          array = collection.to_a
          expect(array.size).to eq 21
        end
      end

      it 'must create similar arrays on multiple calls' do
        result_arrays = []
        (1..10).each do
          VCR.use_cassette('remote_collection_all_pages') do
            result_arrays << collection.to_a
            expect(result_arrays.last.size).to eq 21
          end
        end

        (0..9).each do |i|
          expect(result_arrays[i].size).to eq result_arrays.first.size
        end
      end

      it 'must not repeatedly retrieve from the remote source' do
        VCR.use_cassette('remote_collection_all_pages') do
          expect(collection.to_a.size).to eq 21
        end

        expect(collection.to_a.size).to eq 21
      end
    end
  end
end
