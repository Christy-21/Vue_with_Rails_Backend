module Api
    class FormDataController < ApplicationController
      def create
        form_data = FormData.new(form_data_params)
        if form_data.save
          render json: { message: 'Form data saved successfully' }, status: :created
        else
          render json: { errors: form_data.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      private
  
      def form_data_params
        params.require(:form_data).permit(:username, :email, :address, :city, :nationality, :age)
      end
    end
  end