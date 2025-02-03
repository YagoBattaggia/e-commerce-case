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
        "password": ""
    })

    isProductInDb = productRepo.AddProduct(productPayload)
    config.closeConnection()

    if(isProductInDb):
        return {
            'statusCode': 201,
            'body': json.dumps({"Data": "Produto inserido com sucesso" })
        }
    else:
        return {
            'statusCode': 500,
            'body': json.dumps({"Data": "Erro ao inserir produto" })
        }

