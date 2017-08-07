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
      result_xml = products.to_xml(root: 'shop')
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

  def parse_result(result_xml) 
    final_output = result_xml   
    binding.pry

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.items {
          result_xml.each do 
            xml.item {
              xml.sku   result_xml.first.variants.first.sku
              xml.id    result_xml.first.id 
              xml.brand result_xml.first.vendor
              xml.barcode result_xml.first.variants.first.barcode
              xml.title result_xml.first.title
              xml.body_html result_xml.first.body_html
              xml.price result_xml.first.variants.first.price
              xml.weight result_xml.first.variants.first.weight
              xml.weight_unit result_xml.first.variants.first.weight_unit
              xml.image_src result_xml.first.image.src
            }
          end
        }
      }
    end
    puts builder.to_xml
    builder.to_xml
  end
end
