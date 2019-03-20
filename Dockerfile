# heroes-web-centos7
FROM centos:latest

RUN yum -y update && yum -y install git && yum -y install httpd && \
    curl -sL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs && \
    yum -y clean all && npm install -g @angular/cli@latest

# Set the labels that are used for OpenShift to describe the builder image.
LABEL maintainer="Sun Jingchuan <jason@163.com>" \
      io.k8s.description="Heroes Web" \
      io.k8s.display-name="Heroes Web" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="angular,heroes-web" \
      # this label tells s2i where to find its mandatory scripts(run, assemble, save-artifacts)
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.s2i.destination="/tmp"

ENV APP_ROOT=/opt/heroes
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}

COPY bin ${APP_ROOT}/bin
# Copy the S2I scripts to /usr/libexec/s2i
# COPY .s2i/bin /usr/libexec/s2i

RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd /var/www/html

USER 10001
WORKDIR ${APP_ROOT}

ENTRYPOINT [ "uid_entrypoint" ]

EXPOSE 80

# Inform the user how to run this image.
# CMD ["/usr/libexec/s2i/usage"]
