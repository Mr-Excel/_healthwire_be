class Api::V1::UsersController < ApplicationController
    before_action :authorize_request, except: :create
    before_action :find_user, except: %i[create index]

    def index
        @users = User.all
        if @users.count == 0
            render_json(404,"no record found",[])
        else
            render_json(200, @users.size.to_s+" record/s found!",@users)
        end    
    end

      # POST /users
    def create
        @user = User.new(user_params)
        if @user.save
            render_json(200,"user created!",@user)
        else
            render_json(400,"error while creating user!",@user.errors.full_messages)
        end
    end
    
    private

    def find_user
        @user = User.find_by_username!(params[:_username])
        rescue ActiveRecord::RecordNotFound
            render_json(404,"user not found!",[])
        # render json: { errors: 'User not found' }, status: :not_found
    end

    def user_params
        params.permit(
        :name, :username, :email, :password, :password_confirmation, :role, :gender, :team
        )
    end
end
