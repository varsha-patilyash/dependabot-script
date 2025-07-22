# FROM ghcr.io/dependabot/dependabot-core:0.215.0

# ARG CODE_DIR=/home/dependabot/dependabot-script
# RUN mkdir -p ${CODE_DIR}
# COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
# WORKDIR ${CODE_DIR}

# RUN bundle config set --local path "vendor" \
#   && bundle install --jobs 4 --retry 3

# COPY --chown=dependabot:dependabot . ${CODE_DIR}

# CMD ["bundle", "exec", "ruby", "./generic-update-script.rb"]
# Dockerfile (inside dependabot-script directory)
FROM ruby:3.1

WORKDIR /home/dependabot/dependabot-script

COPY . .

RUN gem install bundler -v 2.4.22 \
 && bundle install

CMD ["irb"]
