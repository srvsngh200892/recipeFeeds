module Recipes
  class Client
    attr_reader :adapter
    DEFAULT_RECIPE_LIMIT = ENV.fetch('DEFAULT_RECIPE_LIMIT', 4)
   
    # Initialize the params and recipe client adapter.
    def initialize(options={}, adapter = nil)
      page = options[:page] || 1
      limit = options[:limit] || DEFAULT_RECIPE_LIMIT
      skip = (page.to_i - 1) * limit.to_i
      @adapter = (adapter || default_adapter).new(skip, limit)
    end
    
    # fetches and Returns the array of recipes with metadeta from the client.
    def list
      begin
        adapter.list
      rescue Exception => e
        Rails.logger.error("Something went wrong #{e}")
        {total:0, resources:[]}
      end
    end
    
    # Fetches and returns the information of particularrecipes from the client.
    def get(id:)
      begin
        adapter.get(id: id)
      rescue Exception => e
        Rails.logger.error("Something went wrong while getting #{id} #{e}")
        {}
      end
    end

    private
    
    # Initialize the default recipe client adapter.
    def default_adapter
      Recipes::ClientAdapters::Contentful
    end
  end
end
