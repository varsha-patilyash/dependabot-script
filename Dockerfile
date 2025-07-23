# FROM ghcr.io/dependabot/dependabot-core:0.215.0

# ARG CODE_DIR=/home/dependabot/dependabot-script
# RUN mkdir -p ${CODE_DIR}
# COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
# WORKDIR ${CODE_DIR}

# RUN bundle config set --local path "vendor" \
#   && bundle install --jobs 4 --retry 3

# COPY --chown=dependabot:dependabot . ${CODE_DIR}

# CMD ["bundle", "exec", "ruby", "./generic-update-script.rb"]


FROM ghcr.io/dependabot/dependabot-core:0.215.0

ARG CODE_DIR=/home/dependabot/dependabot-script
RUN mkdir -p ${CODE_DIR}
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/
WORKDIR ${CODE_DIR}

# Install Faraday retry and other missing gems globally
RUN gem install faraday-retry \
  && bundle config set --local path "vendor" \
  && bundle install --jobs 4 --retry 3

# Copy the rest of the code
COPY --chown=dependabot:dependabot . ${CODE_DIR}

# Debug print in case something goes wrong
ENV BUNDLE_GEMFILE=${CODE_DIR}/Gemfile

CMD ["/bin/bash", "-c", "echo '✅ Starting Dependabot'; bundle exec ruby ./generic-update-script.rb"]
