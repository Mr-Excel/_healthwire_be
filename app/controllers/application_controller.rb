class ApplicationController < ActionController::API
    rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ::NameError, with: :error_occurred
    rescue_from ::ActionController::RoutingError, with: :error_occurred

    def not_found
        render_json(404,"path not found!",[])
    end 

    def error_render_method
        respond_to do |type|
            type.xml { render :template => "errors/error_404", :status => 404 }
            type.all  { render :nothing => true, :status => 404 }
        end
        true
    end
    
    def render_json(code = 000,msg = "",data = [])
        render json: {code: code, msg: msg, data: data}
    end

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
            @decoded = JsonWebToken.decode(header)
            @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
            render_json(e.code,e.message,[])
        rescue JWT::DecodeError => e
            render_json(e.code,e.message,[])
        end
    end

    protected

    def record_not_found(exception)
        render_json(404,exception.message,[])
        # render json: {error: exception.message}.to_json, status: 404
        return
    end

    def error_occurred(exception)
        render_json(500,exception.message,[])
        # render json: {error: exception.message}.to_json, status: 500
        return
    end
end
