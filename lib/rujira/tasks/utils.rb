# frozen_string_literal: true

def client
  url = ENV.fetch('RUJIRA_URL', 'http://localhost:8080')
  @client ||= Rujira::Client.new(url, debug: false)
end

def client_wrapped
  url = ENV.fetch('RUJIRA_URL', 'http://localhost:8080')
  @client_wrapped ||= Rujira::Client.new(url, debug: false, wrap_responses: true)
end

def open_editor(initial_text = '')
  require 'tempfile'

  editor = ENV['EDITOR'] || 'vi'

  file = Tempfile.new(['jira_description', '.txt'])
  file.write(initial_text)
  file.flush
  file.close

  system("#{editor} #{file.path}")

  content = File.read(file.path)
  file.unlink

  content
end

def fetch_options(params, name)
  help = params.map { |k| "#{k}=<VALUE>" }.join(' ')
  options = params.to_h do |k|
    [k.downcase.to_sym, ENV.fetch(k, nil)]
  end
  missing = options.select { |_, v| v.nil? }.keys
  unless missing.empty?
    abort "❌ ERROR: The following required environment variables are missing: #{missing.join(', ').upcase}\n" \
          "✅ USAGE: rake #{name} #{help}"
  end

  options
end
