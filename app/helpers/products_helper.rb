module ProductsHelper
  def self.get_shop_url(str)
    shopurl = "https://#{str}:#{ENV['PASSWORD']}@#{ENV['SHOP_NAME']}.myshopify.com/admin"
    shopurl
  end

  def get_shop_url(str)
    ProductsHelper.get_shop_url(str)
  end

  def parse_result(result_xml) 
    builder = Nokogiri::XML::Builder.new do |xml|
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
            xml.tags do
              result_xml.first.tags.split(",").each do |tag|
                xml.tag tag
              end
            end
            xml.weight result_xml.first.variants.first.weight
            xml.weight_unit result_xml.first.variants.first.weight_unit
            xml.image_src result_xml.first.image.src
            xml.stock_available result_xml.first.variants.first.inventory_quantity
          }
        end
      }
    end
    builder.to_xml
  end
end
