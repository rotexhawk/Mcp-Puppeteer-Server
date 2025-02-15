FROM homeassistant/base-addon:latest

# No need to install anything here, we're just a wrapper

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]