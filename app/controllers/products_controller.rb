class ProductsController < ApplicationController
  
  def index
  end

  def shop
    @api_key = params[:search_box]
    shop_url = "https://#{@api_key}:f93a66c64ef617e20dcdfa1c90ba7995@alibabalhr.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
    
    begin 
      shop = ShopifyAPI::Shop.current
      product_count = ShopifyAPI::Product.count
      products = ShopifyAPI::Product.all
      @result = parse_result(products)

    rescue Exception
      logger.error "Invalid Authentication Key "
    end
    
    redirect_to do |format|
      format.html
      format.xml { render xml: @result}
    end
   
  end


  def parse_result(result_xml)     
    binding.pry
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.items {
        
        }
      }
    end
    puts builder.to_xml

    builder.to_xml
  end
end
