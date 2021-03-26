module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :update_params

      def index
        if params[:isCurrent]
          @users = User.where(id: @current_user.id)
        else
          @users = User.all
        end
        if @users
          @users = @users.limit(@limit).offset(@offset)
        end
        render json: {status: 'SUCCESS', message: 'Loaded users', data: @users.as_json(:include => :articles)}, status: :ok
      end

      def show
        @user = User.find(params[:id])

        render json: {status: 'SUCCESS', message: 'Loaded user', data: @user.as_json(:include => :articles)}, status: :ok
      end

      def update
        @user = current_api_v1_user
        if @article.update_attributes(article_params)
          render json: {status: 'SUCCESS', message: 'Update article', data: @article}, status: :ok
        else
          render json: {status: 'ERROR', message: 'Article not update', data: @article}, status: :unprocessable_entity
        end
      end

      def destroy
        current_api_v1_user.destroy
        render json: {status: 'SUCCESS', message: 'Delete an account', data: current_api_v1_user}, status: :ok
      end

      private
      def article_params
        params.permit(:name, :nickname, :email, :imgUrl)
      end
      def update_params
        @current_user = current_api_v1_user
        @limit = params[:limit] ? params[:limit] : '10'
        @offset = params[:offset] ? params[:offset] : '0'
      end
    end
  end
end
