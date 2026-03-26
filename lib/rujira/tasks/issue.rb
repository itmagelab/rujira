# frozen_string_literal: true

namespace :issue do # rubocop:disable Metrics/BlockLength
  desc 'Create a issue'
  task :create do |t|
    options = fetch_options(%w[PROJECT_KEY SUMMARY DESCRIPTION ISSUETYPE], t.name)
    abort 'ISSUETYPE must start with a capital letter' unless options[:issuetype].match?(/\A[A-Z]/)

    result = client.Issue.create do
      payload fields: {
        project: { key: options[:project_key] },
        summary: options[:summary],
        issuetype: { name: options[:issuetype] },
        description: options[:description]
      }
    end
    puts JSON.pretty_generate(result)
  end

  desc 'Generate a Jira link for creating a new issue'
  task :generate_link do # rubocop:disable Metrics/BlockLength
    require 'cgi'

    me = client_wrapped.Myself.get
    server_info = client.ServerInfo.get
    base_url = server_info['baseUrl']

    print 'Project key (e.g., ABC): '
    project_key = $stdin.gets.chomp
    project = client_wrapped.Project.get(project_key)

    print 'Summary (short description): '
    summary = $stdin.gets.chomp

    puts 'Opening editor for description...'
    description = open_editor

    issue_types = client_wrapped.IssueType.get
    names = issue_types.map(&:name).join('/')
    print "Issue type (#{names}): "
    issue_type_name = $stdin.gets.chomp
    issue_type = issue_types.find do |i|
      i.name.downcase == issue_type_name.downcase
    end

    encoded_summary = CGI.escape(summary)
    encoded_description = CGI.escape(description)

    jira_url = "#{base_url}/secure/CreateIssueDetails!init.jspa" \
               "?pid=#{project.id}" \
               "&summary=#{encoded_summary}" \
               "&description=#{encoded_description}" \
               "&reporter=#{me.name}" \
               "&issuetype=#{issue_type.id}"

    puts "\nGenerated issue creation link:"
    puts jira_url
  end

  desc 'Search issue by fields'
  task :search do |t|
    options = fetch_options(%w[JQL], t.name)
    result = client.Search.get do
      data jql: options[:jql]
    end
    result['issues'].each { |i| puts JSON.pretty_generate(i) }
  end

  desc 'Delete issue'
  task :delete do |t|
    options = fetch_options(%w[ISSUE_ID], t.name)

    client.Issue.del options[:issue_id]
  end

  desc 'Example usage attaching in issue'
  task :attach do |t|
    options = fetch_options(%w[FILE ISSUE_ID], t.name)

    result = client.Issue.attachments options[:issue_id], @options[:file]
    puts JSON.pretty_generate(result)
  end
end
