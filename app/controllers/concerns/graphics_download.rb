module GraphicsDownload
  extend ActiveSupport::Concern

  included do
    private

    def whatsapp_graphics_handler(organization_name, name)
      @quarter = params[:quarter].present? ? params[:quarter].to_i : current_quarter
      @year = params[:year].present? ? params[:year].to_i : current_year

      respond_to do |format|
        format.png do
          filename = graphics_filename(
            quarter_string(quarter_start(@year, @quarter)).split.join('_'),
            organization_name,
            name,
            Date.today)

          render_as_png('/shared/graphics/image_template', filename)
        end
        format.html { render }
      end
    end

    def render_as_png(view_name, filename, options = {})
      default_options = { width: 0,
                          height: 0,
                          enable_smart_width: true,
                          transparent: true,
                          quality: 100,
                          zoom: 1.0 }

      send_data(
        IMGKit.new(
          render_to_string(view_name, formats: [:html], layout: false),
          default_options.merge(options)).to_png,
        type: "image/png",
        filename: filename)
    end

    def graphics_filename(*args)
      "dashboard_snapshot_#{args.join('_')}.png"
    end
  end
end