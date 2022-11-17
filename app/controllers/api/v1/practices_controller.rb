class Api::V1::PracticesController < ApplicationController

    before_action :find_practice, except: %i[create index]

    def index
        @practices = CustomPractice.all.order(id: :desc)
        if @practices.count == 0
            render_json(404,"no record found",[])
        else
            render_json(200, @practices.size.to_s+" record/s found!",@practices)
        end    
    end

      # POST /users
    def create
        @practice = CustomPractice.new(practice_params)
        if @practice.save
            render_json(200,"record created!",@practice)
        else
            render_json(400,"error while creating record!",@practice.errors.full_messages)
        end
    end
    
    # POST /users
    def update
        @practice.update(practice_params)
        if @practice.save
            render_json(200,"record updated!",@uspracticeer)
        else
            render_json(400,"error while updating record!",@practice.errors.full_messages)
        end
    end
    
     # POST /users
    def destroy

        @practice.destroy
        render_json(200,"record Deleted!",@uspracticeer)
    end

    private

    def find_practice
        @practice = CustomPractice.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render_json(404,"user not found!",[])
    end

    def practice_params
        params.permit(
        :id, :name
        )
    end
end
