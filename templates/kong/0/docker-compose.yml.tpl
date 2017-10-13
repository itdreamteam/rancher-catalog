version: '2'
services:
  postgres:
     environment:
       POSTGRES_USER: ${postgres_user}
       POSTGRES_PASSWORD: ${postgres_password}
       POSTGRES_DB: kong
       PGDATA: /data/postgres/data
     labels:
       io.rancher.container.hostname_override: container_name
     tty: true
     image: postgres:9.6.5-alpine
     stdin_open: true
     volumes:
      - {{ .Values.VOLUME_NAME }}:/data/postgres/data
  kong-migration:
    image: kong:0.11.0
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: postgres
      KONG_PG_USER: ${postgres_user}
      KONG_PG_PASSWORD: ${postgres_password}
      KONG_PG_DATABASE: kong
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_HTTP2: on
    depends_on:
      - postgres
    labels:
      io.rancher.container.hostname_override: container_name
    tty: true
    links:
      - postgres
  kong:
    image: kong:0.11.0
    environment:
      KONG_DATABASE: postgres
      KONG_PG_HOST: postgres
      KONG_PG_USER: ${postgres_user}
      KONG_PG_PASSWORD: ${postgres_password}
      KONG_PG_DATABASE: kong
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
    depends_on:
      - postgres
    labels:
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.global: true
    tty: true
    links:
      - postgres
  kong-dashboard:
    image: pgbi/kong-dashboard
    labels:
      io.rancher.container.hostname_override: container_name
    tty: true
volumes:
  {{ .Values.VOLUME_NAME }}:
    driver: ${VOLUME_DRIVER}
    external: true