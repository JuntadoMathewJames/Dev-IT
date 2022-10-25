json.extract! product, :id, :pos_id, :productName, :quantity, :pricePerUnit, :created_at, :updated_at
json.url product_url(product, format: :json)
