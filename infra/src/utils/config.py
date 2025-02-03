import boto3
import pymysql
import logging
import json

# Configurando logger
logger = logging.getLogger(__name__)
logger.setLevel("DEBUG")

connection = None
isColdStart = True

def getSecretValue(secret_name):
    client = boto3.client("secretsmanager", region_name='us-east-1')

    try:
        get_secret_value_response = client.get_secret_value(SecretId=secret_name)

        if "SecretString" in get_secret_value_response:
            secret = get_secret_value_response["SecretString"]
        else:
            secret = base64.b64decode(get_secret_value_response["SecretBinary"])

        return json.loads(secret)
    except Exception as e:
        logger.critical("Erro ao obter dados do secret manager")
        raise e
        

def getConnection(db_info):
    global connection
    global isColdStart

    if isColdStart:
        logger.debug("Cold Start! Criando conexão com o RDS")
        try:
            connection = pymysql.connect(host=db_info.get('host'),
                    user=db_info.get('user'),
                    password=db_info.get('password'),
                    port=db_info.get('port'),
                    database=db_info.get('database'),
                    ssl_ca='./global-bundle.pem',
                    cursorclass=pymysql.cursors.DictCursor
            )
        except Exception as e:
            logger.critical("Erro ao conectar com o RDS")
            logger.critical(e)
            raise e

        isColdStart = False

    connection.ping(reconnect=True)
    return connection

def beginConnection():
    connection.begin()

def commitConnection():
    connection.commit()

def closeConnection():
    connection.close()

def queryRDS(query, params=None):
    with connection.cursor() as cursor:
        logger.debug(query)
        logger.debug(params)
        if(params):
            data = cursor.execute(query, params)
        else:
            data = cursor.execute(query)
        data = cursor.fetchall()
        return data


