FROM ruby:2.6.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libsqlite3-dev
RUN curl -sSL https://cli.openfaas.com | sh

# Copy files and install gems
ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /dalal
WORKDIR /dalal
COPY Gemfile /dalal/Gemfile
COPY Gemfile.lock /dalal/Gemfile.lock
RUN bundle install
COPY . /dalal

# Set environment variables. If overriding, override all.
ARG RAILS_ENV="development"
ARG SECRET_KEY_BASE=ecbab9a70221c207fb8eb1db25abbfe7c74a9d23f9431f0d1f2cc1aea898f5f0ef826bd45e33754fd4e57e510fda43288b699e04673878dbd7ba2e87b592000f
ARG DATABASE_URL="postgresql://localhost"

ENV RAILS_ENV=${RAILS_ENV}
ENV SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV DATABASE_URL=${DATABASE_URL}

# Expose port
EXPOSE 3000

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
