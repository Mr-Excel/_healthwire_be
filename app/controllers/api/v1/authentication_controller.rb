class Api::V1::AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    # POST /auth/login
    def login
        email = params[:email]
        password = params[:password]
        if email && password
            @user = User.find_by_email(params[:email])
            if @user&.authenticate(params[:password])
                token = JsonWebToken.encode(user_id: @user.id)
                time = Time.now + 24.hours.to_i
                LoginHistory.create({user_id: @user.id})
                render_json(200,"user found!",{ token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                                username: @user.username, role: @user.role, name: @user.name})
            elsif @user.size == 0
                render_json(404,"user not found!",[])
            else
                render_json(401,"invalid credentials attempt!",[])
            end
        else
            render_json(400,"email & password required!",[])
        end
    end

    private

    def login_params
        params.permit(:email, :password)
    end
end
