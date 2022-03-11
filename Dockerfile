FROM ruby:3.0.3

# set up workdir
WORKDIR /circuitverse

# install dependencies
# RUN sed -i s/deb.debian.org/mirrors.ustc.edu.cn/g /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y imagemagick shared-mime-info && apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash \
 && apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

# RUN npm config set registry https://registry.npm.taobao.org
RUN npm install -g yarn

COPY Gemfile /circuitverse/Gemfile
COPY Gemfile.lock /circuitverse/Gemfile.lock
COPY package.json /circuitverse/package.json
COPY yarn.lock /circuitverse/yarn.lock
# RUN sed -i s/registry.yarnpkg.com/registry.npmmirror.com/g /circuitverse/yarn.lock

# RUN gem sources --remove https://rubygems.org/ && gem sources -a https://mirrors.ustc.edu.cn/rubygems/
RUN gem install bundler
# RUN bundle config mirror.https://rubygems.org https://mirrors.ustc.edu.cn/rubygems/
RUN bundle install
RUN yarn install

# copy source
COPY . /circuitverse
RUN yarn build

VOLUME [ "/circuitverse" ]
EXPOSE 3000
