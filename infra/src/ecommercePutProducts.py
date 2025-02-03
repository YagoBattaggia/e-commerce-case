import json
import logging
import signal


from utils import config

from shared.Models.product_model import Product
from shared.Repo.product_repo import ProductRepository
productRepo = ProductRepository()

logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")

def exit_gracefully(signum, frame):
    config.closeConnection()

signal.signal(signal.SIGTERM, exit_gracefully)

def lambda_handler(event, context):
    # TODO implement
    # logger.info(config.getSecretValue('rds-password'))
    productPayload = json.loads(event.get('body'))
    data = config.getConnection({
        "user": "admin",
        "host": "ecommerce-rds.c7acu8uesr1y.us-east-1.rds.amazonaws.com",
        "port": 3306,
        "database": "ecommerce",
        "password": "CY_t6jXaAMxqD^%3PApX"
    })

    isProductInDb = productRepo.updateProduct(productPayload)
    config.closeConnection()

    if(isProductInDb):
        return {
            'headers': {
                'Content-Type': "application/json",
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                'Access-Control-Allow-Headers': 'x-api-key',
            },
            'statusCode': 200,
            'body': json.dumps({"Data": "Produto atualizado com sucesso" })
        }
    else:
        return {
            'headers': {
                'Content-Type': "application/json",
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'GET, OPTIONS, DELETE, PUT, POST',
                'Access-Control-Allow-Headers': 'x-api-key',
            },
            'statusCode': 500,
            'body': json.dumps({"Data": "Erro ao atualizar produto" })
        }

