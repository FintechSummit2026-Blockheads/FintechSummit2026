from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
uri = "mongodb+srv://zhaorui031202_db_user:av8FkTEnObCrBtAu@fintechsummit2026.7mhnnoz.mongodb.net/?appName=FintechSummit2026"
# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))
# Send a ping to confirm a successful connection
try:
    print('starting connection to mongodb')
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)