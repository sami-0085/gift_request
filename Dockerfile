ARG RUBY_VERSION=ruby:3.2.2
ARG NODE_VERSION=19

FROM $RUBY_VERSION
ARG RUBY_VERSION
ARG NODE_VERSION

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
&& wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update -qq \
&& apt-get install -y build-essential nodejs yarn vim

# アプリケーションディレクトリの設定
RUN mkdir /app
WORKDIR /app
RUN gem install bundler

# ローカルのGemfileをコンテナへコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY yarn.lock /app/yarn.lock

# Gemfile に記載されているgem(Rails)をインストール
RUN bundle install
# Yarnの依存関係のコピーとインストール
RUN yarn install
# ソースコードをコンテナへコピー
COPY . /app
# Entry pointの設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD [ "rails","server","-b","0.0.0.0" ]