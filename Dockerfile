FROM postgres:16

RUN apt-get update && apt-get install -y --no-install-recommends \
      cron nano less procps iputils-ping postgresql-16-cron \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /archive /backups \
    && chown postgres:postgres /archive /backups

COPY lab-entrypoint.sh pitr_restore.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/lab-entrypoint.sh /usr/local/bin/pitr_restore.sh

ENTRYPOINT ["lab-entrypoint.sh"]
CMD ["postgres"]
