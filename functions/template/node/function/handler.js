"use strict"

module.exports = async (context, callback) => {
    const jsonData = JSON.parse(context);
    return {"headers": {"X-header": "header_text"}, "data" : jsonData}
}
