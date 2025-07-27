FROM pretix/standalone:2024.7.0
USER root
RUN pip3 install pretix-zugferd pretix-sofort pretix-bitpay pretix-servicefees pretix-pages pretix-fontpack-free pretix-bounces pretix-passbook
USER pretixuser
RUN cd /pretix/src && make production
