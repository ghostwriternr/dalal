import json
def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    jsonInput = json.loads(req)
    return {"headers": {"X-Header": "header_text"}, "body": {"text": jsonInput["message"]}}