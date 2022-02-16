FROM ruby:2.7.0
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn



# RUN mkdir /goldfolten
# WORKDIR /goldfolten
# COPY Gemfile /goldfolten/Gemfile
# COPY Gemfile.lock /goldfolten/Gemfile.lock
# RUN bundle install
# COPY . /goldfolten

RUN mkdir /goldfield
WORKDIR /goldfield
COPY Gemfile /goldfield/Gemfile
COPY Gemfile.lock /goldfield/Gemfile.lock
RUN bundle install
COPY . /goldfield

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]