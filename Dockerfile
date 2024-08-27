# Accept optional arguments.
ARG NODE_VERSION="20.17.0-alpine3.20"
ARG RUBY_VERSION="3.3.4-alpine3.20"

# Create a builder image for Node.
FROM node:$NODE_VERSION AS node-builder

# Accept optional arguments.
ARG ENVIRONMENT="production"

# Set environment variables.
ENV NODE_ENV=${ENVIRONMENT}

# Change to a build working directory.
WORKDIR /build

# Copy in files for Yarn.
COPY .yarnrc.yml package.json yarn.lock .
COPY .yarn .yarn

# Install the Node.js dependencies.
RUN yarn install --immutable

# Copy in files for JS assets.
COPY app/assets app/assets
COPY app/javascript app/javascript
COPY config/esbuild.config.js config/esbuild.config.js
COPY config/locales/en.yml config/locals/en.yml

# Build the JS assets.
RUN yarn build

# Copy in files for CSS assets.
COPY app/views app/views
COPY config/tailwind.config.js config/tailwind.config.js

# Build the CSS assets.
RUN yarn build:css

# Create a builder image for Ruby.
FROM ruby:$RUBY_VERSION AS ruby-builder

# Accept optional arguments.
ARG BUNDLE_WITHOUT="development test"
ARG ENVIRONMENT="production"

# Set environment variables.
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
  RAILS_ENV=${ENVIRONMENT}

# Install build dependency requirements.
RUN apk -U upgrade \
  && apk add --no-cache build-base libpq-dev libxml2-dev libxslt-dev

# Change to a build working directory.
WORKDIR /build

# Set Bundler configuration.
RUN bundle config --local without "${BUNDLE_WITHOUT}" \
  && bundle config --local frozen "true"

# Copy in files for Bundler.
COPY Gemfile Gemfile.lock .

# Install the Bundler version specified.
RUN gem install bundler -v $(tail -n1 Gemfile.lock)

# Install the Ruby dependencies.
RUN bundle install

# Create an image for the application.
FROM ruby:$RUBY_VERSION AS application

# Accept optional arguments.
ARG ENVIRONMENT="production"

# Set environment variables.
ENV LD_PRELOAD="libjemalloc.so.2" \
  NODE_ENV=${ENVIRONMENT} \
  RAILS_ENV=${ENVIRONMENT} \
  RUBY_YJIT_ENABLE="1"

# Install dependency requirements.
RUN apk -U upgrade \
  && apk add --no-cache bash jemalloc libpq-dev libxml2-dev libxslt-dev tzdata

# Create the application directory and set it as the working directory.
RUN mkdir -p /home/runner/application
WORKDIR /home/runner/application

# Copy the assets, dependencies, and application into Docker.
COPY --from=node-builder /build/app/assets/builds app/assets/builds
COPY --from=ruby-builder /usr/local/bundle /usr/local/bundle
COPY . .

# Precompile the Bootsnap cache.
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Compile the assets.
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Create an application-specific user.
RUN addgroup --system runner \
  && adduser -G runner --system runner \
  && chown -R runner:runner log tmp

# Switch to the user.
USER runner:runner

# Set a custom entrypoint.
ENTRYPOINT ["bin/docker-entrypoint"]

# Expose the server.
EXPOSE 3000

# Run the server.
CMD ["bin/rails", "server"]
