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

        render json: {status: 'SUCCESS', message: 'Loaded articles', data: @articles.as_json(:include => :user)}, status: :ok
      end

      def show
        @articles = Article.find(params[:id])
        render json: {status: 'SUCCESS', message: 'Loaded articles', data: @articles.as_json(:include => :user)}, status: :ok
      end

      def create
        params = article_params
        @article = current_api_v1_user.articles.new(params)
        if @article.save
          @article.hashTags.split(',').each do |tag|
            @article.tags.create({name: tag})
          end
          render json: {status: 'SUCCESS', message: 'Saved article', data: @article}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Article not saved', data: @article}, status: :unprocessable_entity
        end
      end

      def update
        @article = Article.find(params[:id])
        if @article.update_attributes(article_params)
          render json: {status: 'SUCCESS', message: 'Update article', data: @article}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Article not update', data: @article}, status: :unprocessable_entity
        end
      end

      def destroy
        @article = Article.find(params[:id])
        @article.destroy
        render json: {status: 'SUCCESS', message: 'Delete article', data: @article}, status: :ok
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
