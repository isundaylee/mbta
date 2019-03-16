FROM 'ruby:2.6-alpine'

RUN bundle config --global frozen 1

RUN apk add --update \
  build-base

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle install

COPY . .

CMD ["rackup"]
