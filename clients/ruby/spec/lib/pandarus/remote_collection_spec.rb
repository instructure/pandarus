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
      let(:array) {
        VCR.use_cassette('remote_collection_all_pages') do
          collection.to_a
        end
      }

      it 'must fetch all pages and combine them into a single array' do
        expect(array.size).to eq 21
      end
    end
  end
end
