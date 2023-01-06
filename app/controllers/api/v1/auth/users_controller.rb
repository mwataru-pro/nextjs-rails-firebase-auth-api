module Api
  module V1
    module Auth
      class UsersController < ApplicationController
        skip_before_action :authenticate_user, only: :create

        def create
          FirebaseIdToken::Certificates.request
          raise ArgumentError, 'BadRequest Parameter' if payload.blank?

          @user = User.find_or_initialize_by(uid: payload['sub']) do |user|
            user.name = payload['name']
            user.email = payload['email']
          end

          # emailとpasswordで会員登録した際は、ユーザー名を@user.nameへ格納する
          @user.name = user_params[:name].presence if @user.name.blank?

          if @user.save
            render json: @user, status: :ok
          else
            render json: @user.errors.full_messages, status: :unprocessable_entity
          end
        end

        private

        def token_from_request_headers
          request.headers['Authorization']&.split&.last
        end

        def token
          params[:token] || token_from_request_headers
        end

        def payload
          @payload ||= FirebaseIdToken::Signature.verify token
          # ここで検証してます
        end

        def user_params
          params.require(:user).permit(:name)
        end
      end
    end
  end
end
