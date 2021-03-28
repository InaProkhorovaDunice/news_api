module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :update_params

      def index
        if params[:isCurrent]
          @users = @current_user
        else
          @users = User.all
        end
        if @users && !params[:isCurrent]
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
        if @user.update!(user_params)
          render json: {status: 'SUCCESS', message: 'Update user', data: @user.as_json(:include => :articles)}, status: :ok
        else
          render json: {status: 'ERROR', message: 'User not update', data: @user.as_json(:include => :articles)}, status: :unprocessable_entity
        end
      end

      private
      def user_params
        params.permit(:name, :nickname, :email)
      end
      def update_params
        @current_user = current_api_v1_user
        @limit = params[:limit] ? params[:limit] : '10'
        @offset = params[:offset] ? params[:offset] : '0'
      end
    end
  end
end
