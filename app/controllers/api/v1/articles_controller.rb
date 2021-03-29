module Api
  module V1
    class ArticlesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :update_params

      def index
        if params[:search]
          @query = params[:search]
          if params[:search_by]
            @column = params[:search_by]
            @articles = column.equal? "hashTags" ? Article.search_by_tags(@query) : Article.search_by_user(@query)
          else
            @articles = Article.search(params[:search])
          end
        else
          @articles = Article.all
        end

        if @articles
          @articles = @articles.limit(@limit).offset(@offset)
        end

        json_response({status: 'SUCCESS', message: 'Loaded articles', data: @articles.as_json(:include => :user)})
      end

      def create
        params = article_params
        @article = current_api_v1_user.articles.new(params)
        if @article.save
          @article.hashTags.split(',').each do |tag|
            @article.tags.create({name: tag})
          end
          json_response({status: 'SUCCESS', message: 'Saved article', data: @article})
        else
          json_response({status: 'ERROR', message: 'Article not saved', data: @article}, :unprocessable_entity)
        end
      end

      private
      def article_params
        params.permit(:title, :annotation, :text, :hashTags, :imgUrl)
      end

      def update_params
        @limit = params[:limit] ? params[:limit] : '10'
        @offset = params[:offset] ? params[:offset] : '0'
      end
    end
  end
end
