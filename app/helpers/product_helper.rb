module ProductHelper
  def image_product product
    @link_image = "img/img_product/" + product.image
    @name = product.name
  end
end
