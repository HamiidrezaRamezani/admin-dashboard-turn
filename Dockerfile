#Stage 1 - Install dependencies and build the app
FROM debian:latest

ARG DEBIAN_FRONTEND=noninteractive

# Install flutter dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      git \
      wget \
      unzip \
      ca-certificates \
      libgconf-2-4 \
      gdb \
      libstdc++6 \
      libglu1-mesa \
      fonts-droid-fallback \
      lib32stdc++6 \
      python3 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
# Enable flutter web
RUN flutter channel stable && \
    flutter upgrade && \
    flutter config --enable-web

# Copy files to container and build
WORKDIR /app
COPY . .
RUN flutter pub get && \
    flutter build web

# Stage 2 - Create the run-time image
FROM registry2.iran.liara.ir/platforms/static-platform:base
COPY --from=0 /app/build/web /usr/share/nginx/html