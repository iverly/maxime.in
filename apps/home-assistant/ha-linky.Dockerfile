FROM alpine:latest

LABEL org.opencontainers.image.source=https://github.com/bokub/ha-linky
LABEL org.opencontainers.image.description="HA Linky Standalone"
LABEL org.opencontainers.image.licenses=MIT

# Install Node.js and Git
RUN apk add --no-cache nodejs npm git

# Clone the repository
RUN git clone https://github.com/bokub/ha-linky.git

WORKDIR /ha-linky

# Install dependencies
RUN npm ci --ignore-scripts

# Transpile TypeScript
RUN npm run build

CMD [ "node", "--experimental-modules", "dist/index.js" ]
