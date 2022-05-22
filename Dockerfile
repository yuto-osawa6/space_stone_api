# FROM ruby:2.7.0
# RUN apt-get update -qq && apt-get install -y default-mysql-client vim \
#     sudo \
#     nginx 
#   # && gem install bundler:2.0.1

# RUN mkdir /api
# WORKDIR /api
# COPY Gemfile /api/Gemfile
# COPY Gemfile.lock /api/Gemfile.lock
# RUN bundle install
# COPY . /api

# # COPY entrypoint.sh /usr/bin/
# # RUN chmod +x /usr/bin/entrypoint.sh
# # ENTRYPOINT ["entrypoint.sh"]

# # EXPOSE 3000
# # CMD ["rails", "server", "-b", "0.0.0.0"]

# # ADD . /api
# # RUN mkdir -p tmp/sockets
# # RUN mkdir tmp/pids

# # nginx
# RUN groupadd nginx
# RUN useradd -g nginx nginx
# ADD nginx/nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80

# RUN chmod +x /api/entrypoint.sh

# CMD ["/api/entrypoint.sh"]

FROM ruby:2.7.0
ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y apt-utils default-mysql-client vim \
    build-essential \
    # libpq-dev \
    sudo \
    nginx && \
    gem install bundler:2.1.2

RUN mkdir /api
WORKDIR /api
COPY Gemfile /api/Gemfile
COPY Gemfile.lock /api/Gemfile.lock


    # gem install bundler:2.1.2

RUN bundle install
# COPY . /api
ADD . /api
RUN mkdir -p tmp/sockets
RUN mkdir tmp/pids

# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

# EXPOSE 3000
# CMD ["rails", "server", "-b", "0.0.0.0"]

# ADD . /api
# RUN mkdir -p tmp/sockets
# RUN mkdir tmp/pids
VOLUME /api/tmp

# nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

RUN chmod +x /api/entrypoint.sh

CMD ["/api/entrypoint.sh"]