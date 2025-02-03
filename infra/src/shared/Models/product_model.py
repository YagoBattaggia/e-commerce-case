class ProductItem:
    def __init__(self, item_id, color_id, color_name, color_hex, price, sale_price, image_file, size_id, size_name ,stock_qty):
        self.item_id = item_id
        self.color_id = color_id
        self.color_name = color_name
        self.color_hex = color_hex
        self.price = price
        self.sale_price = sale_price
        self.image_file = image_file
        self.size_id = size_id
        self.size_name = size_name
        self.stock_qty = stock_qty

    def to_dict(self):
        return {
            "item_id": self.item_id,
            "color_id": self.color_id,
            "color_name": self.color_name,
            "color_hex": self.color_hex,
            "price": self.price,
            "sale_price": self.sale_price,
            "image_file": self.image_file,
            "size_id": self.size_id,
            "size_name": self.size_name,
            "stock_qty": self.stock_qty
        }


class Product:
    def __init__(self, product_id, product_name, product_description, category_name, category_description):
        self.product_id = product_id
        self.product_name = product_name
        self.product_description = product_description
        self.category_name = category_name
        self.category_description = category_description
        self.variants = []

    def addVariant(self, variant: ProductItem):
        self.variants.append(variant)

    def to_dict(self):
        return {
            "product_id": self.product_id,
            "product_name": self.product_name,
            "product_description": self.product_description,
            "category_name": self.category_name,
            "category_description": self.category_description,
            "variants": [variant.to_dict() for variant in self.variants],
        }
