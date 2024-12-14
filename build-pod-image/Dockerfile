FROM docker:24.0.7-dind-alpine3.18

# Install dependencies
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
        nodejs \
        npm \
        curl \
        bash \
        bc \
        git \
        sed \
        gawk   

# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    /bin/ash get_helm.sh
