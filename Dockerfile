FROM tarantool/tarantool:latest as my-tnt-app

ENV TARANTOOL_USER_NAME=tnt
ENV TARANTOOL_USER_PASSWORD=tnt
ENV TARANTOOL_SLAB_ALLOC_ARENA=0.1

COPY app.lua /opt/tarantool/

EXPOSE 8080

CMD tarantool /opt/tarantool/app.lua