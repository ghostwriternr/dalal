def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """

    return {"headers": {"X-Header": "header_text"}, "body": {"data": "Webhook payload"}}
