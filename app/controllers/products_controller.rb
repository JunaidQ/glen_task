class ProductsController < ApplicationController
  def index
    @api_key = params[:search_box]
    shop_url = "https://#{@api_key}:f93a66c64ef617e20dcdfa1c90ba7995@alibabalhr.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
    
    shop = ShopifyAPI::Shop.current
    product_count = ShopifyAPI::Product.count
    products = ShopifyAPI::Product.all
    result_xml = products.to_xml(root: 'shop')
    @result = result_xml

    redirect_to do |format|
      format.html
      format.xml { render xml: @result}
    end
   
  end
end
