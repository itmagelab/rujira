# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require_relative '../lib/rujira'

RSpec.describe 'Rujira client behaviour' do # rubocop:disable Metrics/BlockLength
  let(:url) { 'https://localhost:8080' }
  let(:client) { Rujira::Client.new(url) }

  around do |example|
    original = ENV['RUJIRA_TOKEN']
    ENV.delete('RUJIRA_TOKEN')
    example.run
    ENV['RUJIRA_TOKEN'] = original if original
  end

  describe 'argument validation' do
    it 'raises a rescuable error instead of terminating the process' do
      expect { client.Issue.get('') }.to raise_error(Rujira::ValidationError, /Issue ID or KEY is required/)
    end

    it 'validates identifiers of other resources' do
      expect { client.Board.get('') }.to raise_error(Rujira::ValidationError)
      expect { client.Sprint.get('') }.to raise_error(Rujira::ValidationError)
      expect { client.Dashboard.get('') }.to raise_error(Rujira::ValidationError)
    end
  end

  describe 'error handling' do
    it 'raises HTTPError with status and body' do
      stub_request(:get, "#{url}/rest/api/2/project")
        .to_return(status: 500, body: 'boom')

      expect { client.Project.list }.to raise_error(Rujira::HTTPError) { |error|
        expect(error.status).to eq(500)
        expect(error.body).to eq('boom')
      }
    end
  end

  describe 'authorization' do
    it 'does not send an Authorization header when no token is configured' do
      stub_request(:get, "#{url}/rest/api/2/project")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })

      client.Project.list

      expect(
        a_request(:get, "#{url}/rest/api/2/project").with { |req| req.headers.key?('Authorization') }
      ).not_to have_been_made
    end

    it 'sends the bearer token configured on the client' do
      stub_request(:get, "#{url}/rest/api/2/project")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })

      Rujira::Client.new(url, token: 'secret').Project.list

      expect(
        a_request(:get, "#{url}/rest/api/2/project").with(headers: { 'Authorization' => 'Bearer secret' })
      ).to have_been_made
    end

    it 'allows basic authentication for a single request' do
      stub_request(:get, "#{url}/rest/api/2/project")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })

      client.Project.list { basic 'user', 'pass' }

      expect(
        a_request(:get, "#{url}/rest/api/2/project")
          .with(headers: { 'Authorization' => "Basic #{Base64.strict_encode64('user:pass')}" })
      ).to have_been_made
    end
  end

  describe 'request isolation' do
    it 'does not leak params between calls of the same resource' do
      stub_request(:get, "#{url}/rest/api/2/project")
        .to_return(status: 200, body: '[]', headers: { 'Content-Type' => 'application/json' })

      project = client.Project
      project.list { params startAt: 5 }
      project.list

      expect(
        a_request(:get, "#{url}/rest/api/2/project").with(query: { 'startAt' => '5' })
      ).to have_been_made.once
    end
  end

  describe 'resource lookup' do
    it 'accepts the lowercase alias of a resource' do
      expect(client.issue).to be_a(Rujira::Api::Issue)
      expect(client).to respond_to(:issue)
    end
  end

  describe 'wrapped responses' do
    let(:wrapped) { Rujira::Client.new(url, wrap_responses: true) }

    it 'falls back to a generic resource when there is no dedicated class' do
      stub_request(:post, "#{url}/rest/api/2/search")
        .to_return(status: 200, body: '{"issues":[]}', headers: { 'Content-Type' => 'application/json' })

      expect { wrapped.Search.get }.not_to raise_error
    end

    it 'reloads a project through the project API' do
      stub_request(:get, "#{url}/rest/api/2/project/TT")
        .to_return(status: 200, body: '{"key":"TT","id":"1"}', headers: { 'Content-Type' => 'application/json' })

      project = wrapped.Project.get('TT')

      expect(project.reload!.key).to eq('TT')
    end
  end

  describe 'raw responses' do
    it 'finds an issue type by name' do
      stub_request(:get, "#{url}/rest/api/2/issuetype")
        .to_return(status: 200, body: '[{"id":"1","name":"Task"}]', headers: { 'Content-Type' => 'application/json' })

      expect(client.IssueType.get_by_name('Task')).to include('name' => 'Task')
    end
  end
end
