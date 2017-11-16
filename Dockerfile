FROM fintaffy/fintaffy-httpd:tag
RUN echo "hello world"
CMD httpd -D FOREGROUND