class ProductsController < ApplicationController
  include ProductsHelper

  def index
  end

  def shop
    api_key = params[:search_box]
    shop_url = get_shop_url(api_key)
    ShopifyAPI::Base.site = shop_url
    begin 
      shop = ShopifyAPI::Shop.current
      product_count = ShopifyAPI::Product.count
      products = ShopifyAPI::Product.all
      @result = parse_result(products)
    rescue Exception
      logger.error "Invalid Authentication Key "
      result = Nokogiri::XML::Builder.new do |xml|
        xml.error "Invalid Authentication Key"  
      end
      @result = result.to_xml
    end
    render xml: @result
  end
end
