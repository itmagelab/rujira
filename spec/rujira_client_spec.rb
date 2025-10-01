# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require_relative '../lib/rujira'

RSpec.describe Rujira::Client do # rubocop:disable Metrics/BlockLength
  let(:client) do
    described_class.new('https://localhost:8080')
  end

  describe 'Project' do
    it 'Return list of projects' do
      stub = stub_request(:get, 'https://localhost:8080/rest/api/2/project')
             .to_return(
               status: 200,
               body: [{ self: 'http://localhost:8080/rest/api/2/project/10121', id: '10121', key: 'TT' }].to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      projects = client.Project.list

      expect(projects).not_to be_empty
      expect(projects.first['key']).to eq('TT')
      expect(stub).to have_been_requested
    end
  end

  describe 'Issue' do
    it 'Create the issue and return the key' do
      stub = stub_request(:post, 'https://localhost:8080/rest/api/2/issue')
             .with(
               query: { updateHistory: true },
               body: hash_including(fields: { project: { key: 'TT' }, summary: 'New task',
                                              description: 'description.',
                                              issuetype: { name: 'Task' } })
             )
             .to_return(status: 201, body: { key: 'TT-123' }.to_json)

      issue = client.Issue.create do
        method :post
        payload fields: {
          project: { key: 'TT' }, summary: 'New task',
          description: 'description.',
          issuetype: { name: 'Task' }
        }
        params updateHistory: true
      end
      json = JSON.parse(issue)

      expect(json['key']).to eq('TT-123')
      expect(stub).to have_been_requested
    end
  end
end
