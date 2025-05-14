#!/usr/bin/env ruby

require 'rujira'
require 'uri'

class JiraLinkGenerator
  attr_reader :uri

  def initialize(host)
    @host = host
    @uri = URI.parse("#{host}/secure/CreateIssueDetails!init.jspa")
  end

  def params(hash)
    @uri.query = URI.encode_www_form(hash)

    self
  end

  def generate
    puts 'Enter project ID (pid):'
    pid = gets.strip

    puts 'Enter issue type ID (issuetypeid):'
    issuetypeid = gets.strip

    puts 'Enter issue summary:'
    summary = gets.strip

    puts 'Enter priority ID (e.g. 1–5):'
    priority = gets.strip

    puts 'Enter issue description:'
    description = gets.strip

    params({
             pid: pid,
             issuetypeid: issuetypeid,
             summary: summary,
             priority: priority,
             description: description
           })
  end
end

builder = JiraLinkGenerator.new('https://jira.domain.org')
                           .params({ pid: 15_750, issuetypeid: 3, summary: 'Test', priority: 5, description: 'Test' })
builder = JiraLinkGenerator.new('https://jira.domain.org').generate
pp builder.uri.to_s
