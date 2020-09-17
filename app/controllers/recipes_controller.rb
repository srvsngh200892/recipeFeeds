class RecipesController < ApplicationController
  def index
    recipes = Recipes::Client.new(search_params).list
    @results = Kaminari.paginate_array(recipes[:resources], total_count: recipes[:total]).page(params[:page]).per(page_size)
  end

  def show
    @result = Recipes::Client.new().get(id: params[:id])
  end

  private

  def search_params
    params.permit(:search, :page, :limit)
  end

  def page_size
    params[:limit] || ENV.fetch('DEFAULT_RECIPE_LIMIT', 4)
  end
end
