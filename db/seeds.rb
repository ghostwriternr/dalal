# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

template = Template.create([{
    language: 'python',
    content: 'def handle(req):
    """handle a request to the function
    """

    return {
        headers: {"X-Header": "header_text"},
        body: {data: "Webhook payload"}
    }'
}])