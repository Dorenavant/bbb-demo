FROM ruby:2.5.3

# Install bundler
RUN gem install bundler

# Install app dependencies.
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set an environment variable for the install location.
ENV RAILS_ROOT /usr/src/app

# Set an environment variable for secret_key_base
ENV SECRET_KEY_BASE a8ba2065cd4d8a6713e6293ebb0d945fa37cfcdf0ca27a40f358afd4266ffc90a3de74438f6031b4d246a4b38b7c422f949468af14906f85ecf386bd6f28056c

# Make the directory and set as working.
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Set environment variables.
ENV RAILS_ENV production

# Adding project files.
COPY . .

# Install gems.
RUN bundle install --without development test --deployment --clean

# Precompile assets.
RUN bundle exec rake assets:clean
RUN bundle exec rake assets:precompile

# Expose port 80.
EXPOSE 80

# Start the application.
CMD ["bin/start"]
