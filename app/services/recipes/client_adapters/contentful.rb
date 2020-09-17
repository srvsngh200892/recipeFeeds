module Recipes
  module ClientAdapters
    class Contentful

      attr_reader :skip, :limit, :client

      SELECT_FIELDS = [
        'fields.title',
        'fields.description',
        'sys.id',
        'fields.photo',
        'fields.chef',
        'fields.tags'
      ].freeze

      DEFAULT_OPTIONS = {
        select: SELECT_FIELDS.join(','),
        content_type: 'recipe',
        include: 1
      }.freeze
     
     # Initialize the params and contentful client class.
      def initialize(skip, limit)
        @skip = skip
        @limit = limit
        @client ||= ::Contentful::Client.new(client_opts)
      end
      
      # fetches and returns the array of recipes with metadeta from the client.
      def list
        with_error_handling do
          receipes = client.entries(
            DEFAULT_OPTIONS.merge(
              skip: skip,
              limit: limit
            )
          )
          transform_data(receipes)
        end
      end
      
      # Fetches and returns the information of particularrecipes from the client.
      def get(id:)
        with_error_handling do
          details = client.entry(id, DEFAULT_OPTIONS.merge({}))
          return {} if details.nil?
          recipe(details)
        end
      end

      private
      
      #Return the response after tranforming into recipe attributes
      def transform_data(receipes)
        Recipes::Attributes::List.new(
          skip: receipes.skip,
          limit: receipes.limit,
          total: receipes.total,
          resources: receipes.entries.map(&method(:recipe))
        )
      end
      
      #Return the response after tranforming into recipe attributes
      def recipe(details)
        Recipes::Attributes::Detail.new(
          id: details.sys[:id],
          title: details.fields[:title],
          description: details.fields[:description],
          chef_name: details.fields[:chef]&.name,
          photo_url: details.fields[:photo]&.url,
          tag_names: (details.fields[:tags] || []).map(&:name)
        )
      end
     
      #Return the client configuration
      def client_opts
        { access_token: ENV.fetch('CONTENTFUL_ACCESS_TOKEN', '7ac531648a1b5e1dab6c18b0979f822a5aad0fe5f1109829b8a197eb2be4b84c'),
          space: ENV.fetch('CONTENTFUL_SPACE', 'kk2bw5ojx476'),
          environment: ENV.fetch('CONTENTFUL_ENVIRONMENT', 'master'),
          timeout_read: Integer(ENV.fetch('CONTENTFUL_READ_TIMEOUT', 2)),
          timeout_connect: Integer(ENV.fetch('CONTENTFUL_CONNECT_TIMEOUT', 1)),
          timeout_write: Integer(ENV.fetch('CONTENFUL_WRITE_TIMEOUT', 2))
        }
      end

      #Handle error while fetching data from client
      def with_error_handling
        yield
      rescue StandardError => e
        raise ContentFulError, "Error retrieving data from the Contentful API: #{e.message}"
      end

      class ContentFulError < StandardError; end

    end
  end
end
