FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN bundle config --global frozen 1


RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /app