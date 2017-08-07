class ProductsController < ApplicationController
  
  def index
  end

  def shop
    @api_key = params[:search_box]
    # shop_url = "https://#{@api_key}:f93a66c64ef617e20dcdfa1c90ba7995@alibabalhr.myshopify.com/admin"
    shop_url = "https://#{@api_key}:#{ENV['PASSWORD']}@#{ENV['SHOP_NAME']}.myshopify.com/admin"
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

  def parse_result(result_xml) 
    final_output = result_xml   
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.root {
        xml.items {
          result_xml.each do 
            xml.item {
              xml.sku   result_xml.first.variants.first.sku
              xml.collection result_xml.first.product_type
              xml.brand result_xml.first.vendor
              xml.item_id    result_xml.first.id 
              xml.barcode result_xml.first.variants.first.barcode
              xml.title result_xml.first.title
              xml.description result_xml.first.body_html
              xml.price result_xml.first.variants.first.price
              binding.pry
              xml.tags do
                result_xml.first.tags.split(",").each do |tag|
                  xml.tag tag
                end
              end
              xml.weight result_xml.first.variants.first.weight
              xml.weight_unit result_xml.first.variants.first.weight_unit
              xml.image_src result_xml.first.image.src
              xml.inventory_quantity result_xml.first.variants.first.inventory_quantity
            }
          end
        }
      }
    end
    puts builder.to_xml
    builder.to_xml
  end
end
