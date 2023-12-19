FROM pretix/standalone:2023.10.0
USER root
# ZUGFeRD is a German standard allowing to embed structured data in PDF>
RUN pip3 install pretix-zugferd
# Additional Payment Methods
RUN pip3 install pretix-sofort pretix-bitpay
# Additional Pretix Features
RUN pip3 install pretix-servicefees pretix-pages pretix-fontpack-free pretix-bounces
RUN pip3 install pretix-passbook
# Third party: Authentication backend for CAS SSO servers
#RUN pip3 install pretix-cas
USER pretixuser
RUN cd /pretix/src && make production
