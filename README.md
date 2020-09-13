# Dalal

### Connect your services in few lines of code
[Access it here](https://master.d2r6jsqlksznst.amplifyapp.com/)

This project is the UI interaction for Dalal

![alt text](logo.png "Logo")

Dalal helps you in connecting multiple systems to one another with just few lines of code.

1. Create a new channel from the home page.
3. Write a transformation function in any language desired, which will take in the data passed when the webhook is called, and use that to forward the data to desired service in the required format.
4. Add the url of the desired service, where you want to forward the request, in the target URL.
5. Click on Save.

Boom, your channel is ready to be used, copy it's URL and add it from wherever you want to send the request. It will trigger your function, transform the data passed by the sender using the logic you wrote and send it forward to the URL you defined in that format.

In just few lines of code, you connected two different services.

You can also see all the events triggered for the channel in history tab when you are on the channel page.

On the statistics page currently you will the events which were sent in an hour time frame for the current Day. (Improvements coming)

[API documentation](https://documenter.getpostman.com/view/3355451/TVK5eMcp#100481c4-4ab5-4d57-87e3-c64c58b676fe)

### Technologies Used
#### Frontend
- React
- Typescript
- Styled Components
- Ant Design (UI library)
- Nivo (Graph Plottiing)

#### Backend
- Ruby on Rails
- OpenFaas
- Docker
- Sidekiq
- Postgres (Database)


<!-- This README would normally document whatever steps are necessary to get the
application up and running. -->

<!-- Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ... -->
