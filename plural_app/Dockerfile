# Use the official Dart image as a base
FROM dart:stable

# Install Flutter
ARG FLUTTER_VERSION=3.35.1
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter \
 && cd /usr/local/flutter \
 && git checkout ${FLUTTER_VERSION}

# Add Flutter to PATH
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run Flutter doctor and enable web support
RUN flutter doctor -v

WORKDIR /app
RUN mkdir plural_repository

# Clone Plural repository, and checkout stable branch
RUN git clone https://github.com/Ecanus/plural.git ./plural_repository \
 && cd ./plural_repository \
 && git checkout stable

WORKDIR /app/plural_repository/plural_app

# Build Plural web files
RUN pwd
RUN flutter clean
RUN flutter build web --dart-define=POCKETBASE_URL=??

# Move required icons from ./assets to ./web/icons (will override existing icons)
RUN cp ./assets/images/web/icons/* ./web/icons

# Move favicon.png from ./web/icons into ./web (will override existing favicon)
RUN mv ./web/icons/favicon.png ./web/

