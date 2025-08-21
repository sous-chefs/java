#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

TEMURIN_REPOS = {
  '11' => 'adoptium/temurin11-binaries',
  '17' => 'adoptium/temurin17-binaries',
}.freeze

CORRETTO_REPOS = {
  '11' => 'corretto-11',
  '17' => 'corretto-17',
}.freeze

def get_latest_release(repo)
  uri = URI("https://api.github.com/repos/#{repo}/releases/latest")
  response = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    JSON.parse(response.body)
  else
    puts "Failed to fetch release info for #{repo}: #{response.code} #{response.message}"
    nil
  end
end

def verify_url(url)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)

  case response
  when Net::HTTPRedirection
    location = response['location']
    puts "  ✓ URL redirects successfully to: #{location}"
    true
  when Net::HTTPSuccess
    puts '  ✓ URL is directly accessible'
    true
  else
    puts "  ✗ URL is not accessible: #{response.code} #{response.message}"
    false
  end
end

def find_linux_x64_jdk(assets)
  assets.find { |asset| asset['name'] =~ /OpenJDK\d+U-jdk_x64_linux_hotspot.*\.tar\.gz$/ }
end

def check_versions
  puts 'Checking Temurin versions...'
  puts '-' * 50

  TEMURIN_REPOS.each do |version, repo|
    puts "\nChecking Java #{version}..."
    release = get_latest_release(repo)
    next unless release

    tag = release['tag_name']
    puts "Latest release: #{tag}"

    asset = find_linux_x64_jdk(release['assets'])
    if asset
      url = asset['browser_download_url']
      puts "Download URL: #{url}"
      if verify_url(url)
        puts 'Current version in cookbook needs updating!' if url != current_url_in_cookbook(version)
      end
    else
      puts '  ✗ No Linux x64 JDK found in release assets'
    end
  end
end

def current_url_in_cookbook(version)
  # Read the current URLs from openjdk_helpers.rb
  helpers_file = File.join(File.dirname(__FILE__), '..', 'libraries', 'openjdk_helpers.rb')
  content = File.read(helpers_file)

  case version
  when '11'
    content.match(/temurin.*when '11'\s+'(.+?)'/m)&.[](1)
  when '17'
    content.match(/temurin.*when '17'\s+'(.+?)'/m)&.[](1)
  end
end

if __FILE__ == $PROGRAM_NAME
  check_versions
end
