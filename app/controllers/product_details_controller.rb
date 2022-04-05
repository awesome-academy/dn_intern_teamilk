class ProductDetailsController < ApplicationController
  before_action :find_product_detail, only: :show
  def show
    respond_to do |format|
      format.html{redirect_to request.referer}
      format.js
    end
  end

  private

  def find_product_detail
    @product_detail = ProductDetail.find_by id: params[:id]
    return if @product_detail

    flash[:danger] = t "product.product_not_found"
    flash.keep(:danger)
    render js: "window.location = '#{root_path}'"
  end
end
