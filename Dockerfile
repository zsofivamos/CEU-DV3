FROM rocker/shiny

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libxml2-dev
RUN apt-get install -y --no-install-recommends \ 
    libssl-dev

RUN install2.r shinydashboard 
RUN install2.r data.table 
RUN install2.r dplyr 
RUN install2.r tidyverse 
RUN install2.r plotly 
RUN install2.r DT

RUN mkdir /app
COPY *.R /app/
COPY *.csv /app/
COPY *.html /app/

EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app', port = 3838, host = '0.0.0.0')"]