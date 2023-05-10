class Profile::InviteController < ApplicationController
  def show
    @data = Hash.new

    @data[:url] = "https://client.com/register?promoter=#{current_user.username}"
    @data[:qrcode] = RQRCode::QRCode.new(@data[:url]).as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true,
      use_path: true
    )
  end
end
