FROM phusion/passenger-ruby22

RUN apt-get update && apt-get install -y \
    mysql-client \
    python-pip \
    language-pack-ja-base language-pack-ja

# locale
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:en
ENV LC_ALL ja_JP.UTF-8

# awscli
RUN pip install awscli

# my_init.d
RUN mkdir -p /etc/my_init.d
ADD docker/etc/my_init.d/slack.sh /etc/my_init.d/slack.sh
ADD docker/etc/my_init.d/db_migrate.sh /etc/my_init.d/db_migrate.sh
ADD docker/etc/my_init.d/cloud_watch.sh /etc/my_init.d/cloud_watch.sh

# nginx
RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD ./docker/etc/nginx/sites-enabled/app.conf /etc/nginx/sites-enabled/app.conf
EXPOSE 80

# rails
RUN mkdir -p /usr/src/app
ADD . /usr/src/app
ADD docker/usr/src/app/config/database.yml /usr/src/app/config/database.yml
ADD docker/usr/src/app/dotenv /usr/src/app/.env
WORKDIR /usr/src/app

RUN RAILS_ENV=production bundle install --deployment --without test development doc
RUN RAILS_ENV=production bundle exec rake assets:precompile

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
