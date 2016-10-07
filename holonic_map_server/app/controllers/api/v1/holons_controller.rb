class API::V1::HolonsController < API::V1::BaseController
  def show
    @hash = params[:id]
    filename = File.join('holons', @hash)
    if File.exists? filename
      @data = File.read filename
    else
      render_error 'holon not found', 404
    end
  end

  def create
    @hash = Digest::SHA256.hexdigest params[:data]
    @hash = 'Qm' + @hash
    File.open(File.join('holons', @hash), 'w') do |f|
      f.puts params[:data]
    end
  end
end
