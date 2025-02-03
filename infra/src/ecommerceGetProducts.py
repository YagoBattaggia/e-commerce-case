import json
import logging
import signal

from utils import config

from shared.Models.product_model import Product
from shared.Repo.product_repo import ProductRepository
productRepo = ProductRepository()


def exit_gracefully(signum, frame):
    config.closeConnection()

signal.signal(signal.SIGTERM, exit_gracefully)

logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")

def lambda_handler(event, context):
    # TODO implement
    # logger.info(config.getSecretValue('rds-password'))
    data = config.getConnection({
        "user": "admin",
        "host": "ecommerce-rds.c7acu8uesr1y.us-east-1.rds.amazonaws.com",
        "port": 3306,
        "database": "ecommerce",
        "password": ""
    })

    product_id = None
    # Obtendo id de produto, caso tenha
    if event.get("queryStringParameters"):
        product_id = event.get("queryStringParameters").get("id")
        
        
    # product_id = '1'

    if product_id:
        product = productRepo.getProductById(product_id)

        config.closeConnection()

        if not product:
            return {
                'headers': {
                    'Content-Type': "application/json",
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                    'Access-Control-Allow-Headers': 'x-api-key'
                },
                'statusCode': 404,
                'body': json.dumps({"Data": "Produto não encontrado" })
            }
        else:
            return {
                'headers': {
                    'Content-Type': "application/json",
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                    'Access-Control-Allow-Headers': 'x-api-key'
                },
                'statusCode': 200,
                'body': json.dumps(product.to_dict())
            }
    
    else:
        product = productRepo.getAllProducts()

        config.closeConnection()

        if not product:
            return {
                'headers': {
                    'Content-Type': "application/json",
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                    'Access-Control-Allow-Headers': 'x-api-key'
                },
                'statusCode': 404,
                'body': json.dumps({"Data": "Produto não encontrado" })
            }
        else:
            return {
                'headers': {
                    'Content-Type': "application/json",
                    'Access-Control-Allow-Origin': '*',
                    'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                    'Access-Control-Allow-Headers': 'x-api-key'
                },
                'statusCode': 200,
                'body': json.dumps(product)
            }   
