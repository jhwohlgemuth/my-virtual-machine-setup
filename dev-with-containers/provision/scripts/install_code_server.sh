#! /bin/bash
#
# Install Code Server
#
CODE_RELEASE=$(curl -sX GET https://api.github.com/repos/coder/code-server/releases/latest | awk '/tag_name/{print $4;exit}' FS='[""]' | sed 's|^v||')
mkdir -p "${CODE_SERVER_CONFIG_DIR}"/{data,extensions,workspace}
curl -o /tmp/code-server.tar.gz -L "https://github.com/coder/code-server/releases/download/v${CODE_RELEASE}/code-server-${CODE_RELEASE}-linux-amd64.tar.gz"
tar xf /tmp/code-server.tar.gz -C /app/code-server --strip-components=1