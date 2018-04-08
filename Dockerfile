FROM ruby:2.5.0

WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN gem install bundler && bundle install

COPY . /jekyll
WORKDIR /jekyll

EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--incremental"]
