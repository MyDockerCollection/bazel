FROM quay.io/spivegin/openjdk

## TLM Bazel Build Container
ENV DART_VERSION=1.24.3 GO_VERSION=1.9.2
RUN apt-get update
RUN apt-get install -y tar git curl wget apt-transport-https ca-certificates gnupg2

# Install Bazel
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add
RUN apt-get -y update &&\
    apt-get -y install bazel &&\
    apt-get -y upgrade bazel

# Install Dartlang
RUN mkdir /opt/dart /opt/dart/code /opt/dart/data /opt/dart/bin /opt/dartlang
RUN cd /opt/dartlang/ && \
    curl -O https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip && \
    unzip dartsdk-linux-x64-release.zip && \
    rm dartsdk-linux-x64-release.zip
ENV PATH /opt/dartlang/dart-sdk/bin:$PATH

# Cleaning up APT
RUN apt-get clean && \
    rm -rf /var/cache/apt/*


# Install Golang
# https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz
# tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz
# export PATH=$PATH:/usr/local/go/bin

RUN mkdir /opt/golang &&\
    cd /opt/golang &&\
    wget https://redirector.gvt1.com/edgedl/go/go${GO_VERSION}.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz &&\
    cd ~ &&\
    rm -rf /opt/golang/go${GO_VERSION}.linux-amd64.tar.gz
#    export PATH=$GOPATH/opt/ &&\
#    echo "\nexport GOROOT=/opt/go/\nexport PATH=$PATH:$GOROOT/home/source \nexport PATH=$PATH:/opt/go/bin" >> /etc/profile


# Set environment variables.
ENV GOPATH=/opt/golang
ENV PATH=/usr/local/go/bin:/usr/lib/dart/bin:$PATH






