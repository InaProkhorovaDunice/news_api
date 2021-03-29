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

        json_response(
            {status: 'SUCCESS', message: 'Loaded users', data: @users.as_json(:include => :articles)}
        )
      end

      def show
        @user = User.find(params[:id])

        json_response(
            {status: 'SUCCESS', message: 'Loaded user', data: @user.as_json(:include => :articles)}
        )
      end

      def update
        if @current_user.update!(user_params)
          json_response(
              {status: 'SUCCESS', message: 'Update user', data: @current_user.as_json(:include => :articles)}
          )
        else
          json_response(
              {status: 'ERROR', message: 'User not update', data: @current_user.as_json(:include => :articles)},
              :unprocessable_entity
          )
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
