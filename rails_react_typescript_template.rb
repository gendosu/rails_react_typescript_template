# Spec driven test framework
gem 'rspec-rails'

gem 'rubocop', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rspec', require: false

base_dockerfile = ask("Docker image to use (default: gendosu/ruby-node:ruby-2.6.6-node-12.4.0)")

file 'Dockerfile', <<-EOF
  # 本体
  #
  # VERSION               0.0.1

  FROM #{base_dockerfile}

  ENV PATH "/products/node_modules/.bin:$PATH"

  ADD . /app
  WORKDIR /app

  RUN apt-get update \
    && apt-get install -y \
    locales \
    chromium \
    cmake \
    vim \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

  ENV LANG C.UTF-8
  ENV EDITOR vim

  RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

  RUN echo "set mouse-=a" >> /root/.vimrc

  # RUN yarn

  RUN bundle

  # RUN bundle exec rails assets:precompile

  ENTRYPOINT ["./entrypoint.sh"]
EOF

rails_command "db:migrate"
