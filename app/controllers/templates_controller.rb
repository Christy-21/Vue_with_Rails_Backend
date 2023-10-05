class TemplatesController < ApplicationController
  protect_from_forgery except: :create

  def index
    templates = Template.all
    templates_data = templates.as_json(only: [:id, :title, :description, :created_at, :updated_at, :first_template_id, :total_pages, :enabled, :is_public])
    templates_data.each do |template_data|
      template_data['thumbnail_url'] = thumbnail_url(template_data['id'])
    end
    render json: templates_data, status: :ok
  end

  def show
    file_path = Rails.root.join('path_to_your_pdf_file.pdf')
    send_file file_path, type: 'application/pdf', disposition: 'inline'
    @template = Template.find(params[:id])
    @associated_filenames = @template.active_storage_blobs.pluck(:filename)
    @blob = ActiveStorageBlob.find_by(filename: 'your_filename_here')
    @associated_template_name = @blob&.template&.templateName
  end

  def create
    template = Template.new(template_params)

    if params[:file].present?
      pdf_path = params[:file].tempfile.path
      jpeg_path = "#{Rails.root}/tmp/#{SecureRandom.hex}.jpeg"
    
      MiniMagick::Tool::Convert.new do |convert|
        convert.density('300') 
        convert << pdf_path
        convert << jpeg_path
      end
    
      original_filename = params[:file].original_filename
      jpeg_filename = "#{File.basename(original_filename, ".*")}.jpeg"
      template.scanned_copy.attach(io: File.open(jpeg_path), filename: jpeg_filename, content_type: 'image/jpeg')
      File.delete(jpeg_path)
    end

    if template.save
      render json: { message: 'Template saved successfully!', template: template }, status: 200
    else
      render json: { message: 'Failed to save template.', errors: template.errors }, status: 400
    end

  rescue ActiveStorage::InvariableError => e
    Rails.logger.error("Error generating thumbnail for template_id: #{template_id}. #{e.message}")
    render json: { message: 'An error occurred while processing the request.', error: e.message }, status: 500
  rescue => e
    Rails.logger.error("Error in TemplatesController#create: #{e.message}")
    render json: { message: 'An error occurred while processing the request.', error: e.message }, status: 500
  end
  
  def templatesid
    template = Template.find(params[:template_id])
  
    if template&.scanned_copy&.attached?
      image = template.scanned_copy
  
      if image.image? || image.content_type.in?(%w[image/jpeg image/png application/pdf])
        image_url = url_for(image)
        render json: { imageUrl: image_url }
      else
        Rails.logger.error("Invalid file type for template_id: #{params[:template_id]}.")
        render json: { error: 'Invalid file type.' }, status: 400
      end
    else
      Rails.logger.error("No valid image found for template_id: #{params[:template_id]}.")
      render json: { error: 'No image found.' }, status: 404
    end
  end
  
  
  
  
  private

  def template_params
    params.permit(:templateName, :templateDescription, :file)
         
  end

  def thumbnail_url(template_id)
    template = Template.find_by(id: template_id)

    if template&.scanned_copy&.attached?
      image = template.scanned_copy

      if image.image?
        processed_image = image.variant(resize: '250x250>')
        url_for(processed_image)
      elsif image.content_type == 'application/pdf'
        url_for(image)
      else
        Rails.logger.error("Invalid file type for template_id: #{template_id}.")
        nil
      end
    else
      Rails.logger.error("No valid image or PDF found for template_id: #{template_id}.")
      nil
    end
  end
end



