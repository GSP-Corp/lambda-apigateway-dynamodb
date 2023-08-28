import boto3


# Lambda hello world function
def handler(event, context):
    table = Conn().connect_to_table()
    data = Conn().get_data()
    print(table)
    print(data)
    return {
        'statusCode': 200,
        'body': 'Hello World'
    }

# Connect to dynamodb
# my-lambda-project-dynamodb-table
class Conn:
    
    def __init__(self):
        self.dynamodb = boto3.resource('dynamodb')
        self.table = self.dynamodb.Table('my-lambda-project-dynamodb-table')

    def connect_to_table(self):
        return self.table
    
    def get_data(self):
        return self.table.scan()

    