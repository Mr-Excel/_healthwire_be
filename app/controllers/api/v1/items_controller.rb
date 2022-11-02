require "json"
require 'csv'    

class Api::V1::ItemsController < ApplicationController
    $uniqueParams = ["mg", "ml", "mcg", "mm", "cm", "gm", "g"];

    
    def regexp(param, name)
        exp = {
            g: [/(\d+g)/,/(\d+ g)/],
        mg: [/(\d+mg)/,/(\d+ mg)/],
        ml: [/(\d+ml)/,/(\d+ ml)/],
        mcg: [/(\d+mcg)/,/(\d+ mcg)/],
        mm: [/(\d+mm)/,/(\d+ mm)/],
        cm: [/(\d+cm)/,/(\d+ cm)/],
        gm: [/(\d+gm)/,/(\d+ gm)/]
        }
        res = []
        exp[param.to_sym].each do |match|
            res.push(name.to_enum(:scan,match).map {$&})
        end
        return res.reduce([], :concat)
    end

    $category = {
        cap: "capsule",
        inj: "Injection",
        lotion: "lotion",
        mask: "mask",
        insulin: "insulin",
        ing: "Injection",
        syp: "Syrup",
        tab: "tablet",
        drop: "drops",
        drp: "drops",
        susp: "suspension",
        ssp: "suspension",
        sol: "solution",
        solution: "solution",
        suspension: "suspension",
        capsule: "capsule",
        injection: "Injection",
        syrup: "Syrup",
        tablet: "tablet",
        gel: "gel",
        cream: "cream",
        crm: "cream"
    }

    def practices
        begin
            @respo = ActiveRecord::Base.connection.execute("select * from custom_practices")
            render_json(200, @respo.count.to_s+" record/s found!",@respo)
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def mapped_items
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = ActiveRecord::Base.connection.execute("SELECT * from formatted_items f inner join mapped_items m on f.id = m.formatted_item_id where f.custom_practice_id = #{practice_id} ")
                render_json(200, @respo.count.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def exactMatch
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = ActiveRecord::Base.connection.execute("SELECT d.id as def_id,d.item_name as def_item_name, d.custom_id as def_custom_id, d.categories as def_categories, d.param_type as def_param_type, d.param_value as def_param_value, d.name as def_name, d.remaining_name as def_remaining_name, d.second_name as def_second_name,f.id as p_id,f.item_name as p_item_name, f.custom_id as p_custom_id, f.categories as p_categories, f.param_type as p_param_type, f.param_value as p_param_value, f.name as p_name, f.remaining_name as p_remaining_name, f.second_name as p_second_name, case when m.id is not null then 'mapped' else '' end as status FROM public.formatted_items as f inner join public.formatted_items d on d.item_name = f.item_name and d.custom_practice_id != #{practice_id} left outer join mapped_items m on f.id = m.formatted_item_id where m.id is null and f.custom_practice_id = #{practice_id} ")
                render_json(200, @respo.count.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def fullMatch
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = ActiveRecord::Base.connection.execute("SELECT d.id as def_id,d.item_name as def_item_name, d.custom_id as def_custom_id, d.categories as def_categories, d.param_type as def_param_type, d.param_value as def_param_value, d.name as def_name, d.remaining_name as def_remaining_name, d.second_name as def_second_name,f.id as p_id,f.item_name as p_item_name, f.custom_id as p_custom_id, f.categories as p_categories, f.param_type as p_param_type, f.param_value as p_param_value, f.name as p_name, f.remaining_name as p_remaining_name, f.second_name as p_second_name, case when m.id is not null then 'mapped' else '' end as status  FROM public.formatted_items as f inner join public.formatted_items d on d.name = f.name and d.custom_practice_id != #{practice_id} and d.second_name = f.second_name and d.param_type = f.param_type and d.param_value = f.param_value and d.categories = f.categories left outer join mapped_items m on f.id = m.formatted_item_id where f.custom_practice_id =  #{practice_id}  and m.id is null and f.id not in (select * from (SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.item_name = f.item_name where f.custom_practice_id = #{practice_id}) as a)")
                render_json(200, @respo.count.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def lowMatch
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = ActiveRecord::Base.connection.execute("SELECT d.id as def_id,f.id as p_id,d.item_name as def_item_name, d.custom_id as def_custom_id, d.categories as def_categories, d.param_type as def_param_type, d.param_value as def_param_value, d.name as def_name, d.remaining_name as def_remaining_name, d.second_name as def_second_name,f.item_name as p_item_name, f.custom_id as p_custom_id, f.categories as p_categories, f.param_type as p_param_type, f.param_value as p_param_value, f.name as p_name, f.remaining_name as p_remaining_name, f.second_name as p_second_name FROM public.formatted_items as f inner join public.formatted_items d on d.name = f.name and d.custom_practice_id != #{practice_id} and d.param_type = f.param_type and d.param_value = f.param_value and d.categories = f.categories left outer join mapped_items m on f.id = m.formatted_item_id where m.id is null and f.custom_practice_id = #{practice_id} and f.param_type != '' and f.id not in (select * from (SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.item_name = f.item_name where f.custom_practice_id = #{practice_id} union all SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.name = f.name and d.second_name = f.second_name and d.param_type = f.param_type and d.param_value = f.param_value and d.categories = f.categories where f.custom_practice_id =  #{practice_id}) as a)")
                render_json(200, @respo.count.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

     def remaining
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = ActiveRecord::Base.connection.execute("select * from formatted_items f  left outer join mapped_items m on f.id = m.formatted_item_id  where m.id is null and f.custom_practice_id =  #{practice_id} and f.id not in (select * from (SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.item_name = f.item_name where f.custom_practice_id = #{practice_id} union all SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.name = f.name and d.second_name = f.second_name and d.param_type = f.param_type and d.param_value = f.param_value and d.categories = f.categories where f.custom_practice_id =  #{practice_id} union all SELECT distinct f.id FROM public.default_items as d inner join public.formatted_items f on d.name = f.name and d.param_type = f.param_type and d.param_value = f.param_value and d.categories = f.categories where f.custom_practice_id = #{practice_id} and f.param_type != '' ) as a)")
                render_json(200, @respo.count.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def index
        begin
            practice_id = params[:practice_id]
            if practice_id
                @respo = FormattedItem.find_by(custom_practice_id: practice_id)
                render_json(200, @respo.size.to_s+" record/s found!",@respo)
            else
                render_json(400, "Practice Id is required!",[])
            end
        rescue => e
            @error = e.message
           render_json(200, @error,[]) 
        end
    end

    def create_map_items 
        data = params[:data]
        @respo = MappedItem.insert_all(data)
        render_json(200, @respo.size.to_s+" record/s found!",@respo)
    end

    def create
        data = params["data"]
        type = params["type"] == "0" 
        practice_id = params["practice_id"]
        begin
            if type
                if data.nil? || data.length == 0
                    @respo = {code: 404, message: "Data Not Found!"}
                else
                    data = params["data"]
                    # file = File.open("./data.json")
                    # data = JSON.load file
                    @response = manipulate(data,1)
                    @filter = @response.select { |row| row["item_name"] != '' }
                    @inserted = DefaultItem.insert_all(@filter)
                    render_json(200, @inserted.length.to_s+" record/s found!",@inserted)
                    # @respo = {inserted_objects: @filter.count, response: @filter}
                end
            else
                if practice_id.nil? || practice_id.to_s.length == 0
                    render_json(404,"Practice Id Not Found!",[])
                elsif data.nil? || data.length == 0
                    @respo = {code: 404, message: "Data Not Found!"}
                    render_json(404,"Data Not Found!",[])
                else
                    @response = manipulate(data,practice_id)
                    @filter = @response.select { |row| row["item_name"] != '' }
                    ActiveRecord::Base.connection.execute("delete from formatted_items where custom_practice_id = #{practice_id}")
                    @inserted = FormattedItem.insert_all(@filter)
                    render_json(200, @inserted.length.to_s+" record/s found!",@inserted)
                end
            end
        rescue => e
            render_json(500, "Error: "+e.message.to_s,[])
        end
    end

    def param_checker(name)
        type = {type: "",value:""}
        count = 0
        $uniqueParams.each do |param|
            filtered = regexp(param,name)
            if filtered.length > 0 && count == 0
                count = 1
                type[:type] = param
                type[:value] = filtered[0].scan(/\d+/)[0]
            end
        end
        return type
    end

    def name_getter(obj)
        full_name = obj[:item_name]
        param_type = obj[:param_type]
        param_value = obj[:param_value]
        
        words = [param_type,param_value]
        words.concat($category.keys)
        reg = Regexp.new(words.join("|"))
        name = full_name.downcase.gsub(reg, '').strip
        return name
    end

    def manipulate(data,practice_id)
        # puts data[0]
        begin 
        data.each do |item, index|
            if !item[:type]
                
                words = item["item_name"].class == String ? item["item_name"].to_s.downcase.split(/\W+/) : []
                item["item_name"] = item["item_name"].to_s.split(/\W+/).join(" ")
                item["quantity"] = item["quantity"] ? item["quantity"].to_i : 0
                
                # puts words
                name = words.join(" ")
                paramLocation = param_checker(name)
                # puts name
                item["categories"] = []
                keys = $category.keys
                keys.each do |key|
                    search = name.index(key.to_s)
                    if search
                        item["categories"].push($category[key.to_sym])
                    end
                end
                item["categories"] = item["categories"].length > 0 ? item["categories"][0] : ""
                item["param_type"] = paramLocation[:type]
                item["param_value"] = paramLocation[:value].length > 0 ? paramLocation[:value].to_i : 0

                lookup = {full: $category.values,short: $category.keys}
                refine_words = name.gsub(Regexp.new(lookup[:full].join("|").downcase), '').gsub(Regexp.new(lookup[:short].join("|").downcase), '')

                item_id = item["Id"] ? item["Id"].to_i : item["id"].to_i
                item["custom_id"] = item_id.size != 4 ? item_id.to_s[0..6].to_i : item_id
                item["custom_practice_id"] = practice_id.to_i

                _name = name_getter(item)
                item["remaining_name"] = _name
                nameArray = _name.split(" ").sort_by { |str| -str.length }
                item["name"] = nameArray[0]
                item["second_name"] = nameArray[1]
                item.delete("id")
            end
        end
        return data
        rescue => error
            puts error.message
        end
    end

    def wordChecker(word)
        name = word ? word : ""
        name_ = name.length >= 4 && name.class == String ? name.downcase : ""
        return name_.match? Regexp.union($uniqueParams) ? "" : name
    end
  
  def final_transformation(data)
        uniqueMedicines = [];
        response = {};
        data.each do |row|
            if !uniqueMedicines.index(row[:name])
                uniqueMedicines.push(row[:name]);
            end
        end
        uniqueMedicines.each do |row|
            response[row] = data.select { |n| n[:name] == row }
        end
        return response;
    end

    private
    
    def mapping_params
        params.require(:mapped_items).permit(:custom_practice_id, :default_item_id, :formatted_item_id)
    end

end
