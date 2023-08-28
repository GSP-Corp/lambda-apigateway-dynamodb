# Lambda hello world function
def handler(event, context):
    return {
        'statusCode': 200,
        'body': 'Hello World'
    }