module Java
  module Cookbook
    module TemurinHelpers
      # Fetch available Temurin releases from Adoptium API
      def available_temurin_releases
        require 'net/http'
        require 'json'
        require 'uri'

        uri = URI('https://api.adoptium.net/v3/info/available_releases')
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          releases = JSON.parse(response.body)
          Chef::Log.info("Available Temurin releases: #{releases}")
          releases
        else
          Chef::Log.warn("Failed to fetch Temurin releases: #{response.code} #{response.message}")
          {}
        end
      rescue => e
        Chef::Log.warn("Error fetching Temurin releases: #{e.message}")
        {}
      end

      # Get available LTS versions
      def temurin_lts_versions
        releases = available_temurin_releases
        return [] unless releases.is_a?(Hash) && releases.key?('available_lts_releases')

        releases['available_lts_releases']
      end

      # Get latest LTS version
      def temurin_latest_lts
        lts = temurin_lts_versions
        lts.empty? ? '17' : lts.max.to_s
      end

      # Helper to determine if a version is available as LTS
      def temurin_version_available?(version)
        version = version.to_s
        lts = temurin_lts_versions

        return true if lts.include?(version.to_i)
        false
      end
    end
  end
end

# Ensure the helper is included in the recipe DSL
Chef::DSL::Recipe.include Java::Cookbook::TemurinHelpers
Chef::Resource.include Java::Cookbook::TemurinHelpers
