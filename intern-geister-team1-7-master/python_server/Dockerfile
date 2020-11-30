FROM python:3.6.8

COPY server/requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# 備考:docker composeの場合はマウントする
COPY server /usr/src/app

# コンテナからホスト(ubuntu)に開放するポートの指定
EXPOSE 5000

WORKDIR /usr/src/app

ENV ENTRYKIT_VERSION 0.4.0

# mysql clientとentrykitの導入
RUN apt-get update \
    && apt-get install -y mysql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

# 起動時引数に
# testが与えられた場合はテストコードを実行
# serverが与えられるか、引数が与えられなかった場合は、サーバーを起動する
ENTRYPOINT [ \
  "switch", \
    "test=sh test.sh", \
    "server=python3 run.py", \
    "--", "python3", "run.py" \
]
