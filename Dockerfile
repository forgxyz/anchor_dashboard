FROM fishtownanalytics/dbt:0.21.0
WORKDIR /support
RUN mkdir /root/.dbt
COPY profiles.yml /root/.dbt
RUN mkdir /root/anchor_dashboard
WORKDIR /anchor_dashboard
COPY . .
EXPOSE 8080
ENTRYPOINT [ "bash"]
