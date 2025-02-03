from utils import config
from shared.Models.product_model import Product, ProductItem

from pypika import MySQLQuery, Table, Parameter

class ProductRepository:
    def getProductById(self, product_id):
        
        # Obtendo produto
        data = config.queryRDS( f"SELECT product_id, product_name, product_description, category_name, category_description FROM view_product WHERE product_id = {product_id}" )
        print(data)

        # Early return se produto não existir
        if not data:
            return None
        
        data = data[0]
        product = Product(
            product_id=data["product_id"],
            product_name=data["product_name"],
            product_description=data["product_description"],
            category_name=data["category_name"],
            category_description=data["category_description"]
        )  
        
        # Obtendo variantes do produto
        product_variants = config.queryRDS( f"SELECT product_id, product_item_id, color_name, color_hex, price, sale_price, image_file, size_name, stock_qty  FROM view_product_item2 WHERE product_id = {product_id}" )

        print(product_variants)

        for variant in product_variants:
            print(variant)
            product.addVariant(ProductItem(
            item_id=variant["product_item_id"],
            color_name=variant["color_name"],
            color_hex=variant["color_hex"],
            price=variant["price"],
            sale_price=variant["sale_price"],
            image_file=variant["image_file"],
            size_name=variant["size_name"],
            stock_qty=variant["stock_qty"]
        ))
        
        return product

    def getAllProducts(self):
        
        data = config.queryRDS( f"SELECT product_id, product_name, product_description, category_name, category_description FROM view_product" )
        print(data)

        # Early return se produto não existir
        if not data:
            return None

        products = {
            p["product_id"]: Product(
                product_id=p["product_id"],
                product_name=p["product_name"],
                product_description=p["product_description"],
                category_name=p["category_name"],
                category_description=p["category_description"]
                )
            for p in data
        }

        print(products)

        # Obtendo variantes do produto
        product_variants = config.queryRDS( f"SELECT product_id, product_item_id, color_name, color_hex, price, sale_price, image_file, size_name, stock_qty  FROM view_product_item2" )

        print(product_variants)

        for variant in product_variants:
            productId = variant["product_id"]
            if(productId in products):
                products[productId].addVariant(ProductItem(
                    item_id=variant["product_item_id"],
                    color_name=variant["color_name"],
                    color_hex=variant["color_hex"],
                    price=variant["price"],
                    sale_price=variant["sale_price"],
                    image_file=variant["image_file"],
                    size_name=variant["size_name"],
                    stock_qty=variant["stock_qty"]
                    )
                )
        
        products = [product.to_dict() for product in products.values()]

        return products

    def AddProduct(self, productPayload):

        # Obtendo Categoria
        category = Table('category')
        categoryIdQuery = MySQLQuery.from_(category).select('category_id').where( (category.category_name == productPayload.get('category_name')) & (category.category_description == productPayload.get('category_description')))
        
        categoryId = int(config.queryRDS(str(categoryIdQuery))[0]['category_id'])

        if not categoryId:
            raise ValueError("Categoria não encontrada!")

        # config.beginConnection()

        # Inserindo Produto
        productTable = Table('product')

        productQuery = MySQLQuery.into(productTable).columns("product_name", "product_description", "product_category_id").insert(
            Parameter('%s'),
            Parameter('%s'),
            Parameter('%s'))
        params = (
            productPayload.get('product_name'),
            productPayload.get('product_description'),
            categoryId
        )
        config.queryRDS(str(productQuery), params)
       
        product_id = config.queryRDS("SELECT LAST_INSERT_ID() AS product_id")


        product_id = product_id[0].get('product_id')


        for variant in productPayload.get('variants'):

            # Inserindo cor
            colorQuery = MySQLQuery.into(Table('product_color')).columns("color_name", "color_hex").insert(
                Parameter('%s'),
                Parameter('%s'))
            params = (
                variant.get('color_name'),
                variant.get('color_hex'),
            )
            config.queryRDS(str(colorQuery), params)
            colorId = config.queryRDS("SELECT LAST_INSERT_ID() AS color_id")[0].get('color_id')


            # Inserindo Tamanho
            colorQuery = MySQLQuery.into(Table('product_size')).columns("stock_qty", "size_name").insert(
                Parameter('%s'),
                Parameter('%s'))
            params = (
                variant.get('stock_qty'),
                variant.get('size_name'),
            )
            config.queryRDS(str(colorQuery), params)
            sizeId = config.queryRDS("SELECT LAST_INSERT_ID() AS size_id")[0].get('size_id')

            # Inserindo Item Variante
            colorQuery = MySQLQuery.into(Table('product_item')).columns("product_id", "product_color_id", "price", "sale_price", "size_id").insert(
                Parameter('%s'),
                Parameter('%s'),
                Parameter('%s'),
                Parameter('%s'),
                Parameter('%s'))
            params = (
                product_id,
                colorId,
                variant.get('price'),
                variant.get('sale_price'),
                sizeId
            )
            config.queryRDS(str(colorQuery), params)
            
        config.commitConnection()

        return True

    def deleteProduct(self, productPayload):
        
        config.beginConnection()

        # Excluindo Variantes
        table = Table('product_item')
        variantsQuery = MySQLQuery.from_(table).delete().where(table.product_id == Parameter("%s"))
        params = (
            productPayload.get('product_id')
        )
        config.queryRDS(str(variantsQuery), params)


        # Excluindo produto
        table = Table('product')
        variantsQuery = MySQLQuery.from_(table).delete().where(table.product_id == Parameter("%s"))
        params = (
            productPayload.get('product_id')
        )
        config.queryRDS(str(variantsQuery), params)

        config.commitConnection()

        return True

