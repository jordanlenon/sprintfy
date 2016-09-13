FROM ruby:2.2.5

ADD ./ /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y build-essential nodejs mysql-client && \
    gem install bundler && \
    bundle install

CMD bundle exec rails server -b 0.0.0.0 -p 80
