class Api::V1::<%= class_name %>Controller < ApplicationController
  respond_to :json

  def index
    if params[:ids]
      render json: <%= model_name %>.find(params[:ids])
    else
      render json: <%= model_name %>.all
    end
  end

  def create
  <%= singular_table_name %> = <%= model_name %>.new(<%= singular_table_name %>_params)

    if check_user && <%= singular_table_name %>.save
      render json: <%= singular_table_name %>, status: :created
    else
      render json: { errors:  <%= singular_table_name%>.errors.as_json }, status: 420
    end
  end

  def destroy
    <%= singular_table_name %> = <%= model_name %>.find(params[:id])
    if check_user && <%= singular_table_name%>.destroy
      render json: {}
    else
      render json: { errors:  <%= singular_table_name %>.errors.as_json }, status: 420
    end
  end

  def show
    render json: <%= model_name %>.find(params[:id])
  end

  def update
    <%= singular_table_name %>= <%= model_name %>.find(params[:id])

    if check_user && <%= singular_table_name %>.update(<%= singular_table_name %>_params)
      render json: <%= singular_table_name%>
    else
      render json: <%= singular_table_name %>.errors, status: :unprocessable_entity
    end
  end

  def <%= singular_table_name %>_params
    params.require(<%= singular_table_name.to_sym %>).permit!
  end

  def check_user
    #current_user.admin
    true
  end
end
