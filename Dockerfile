FROM ruby:2.6.3

# Copy files and install dependencies
RUN mkdir /dalal
WORKDIR /dalal
COPY Gemfile /dalal/Gemfile
COPY Gemfile.lock /dalal/Gemfile.lock
RUN bundle install
COPY . /dalal

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
