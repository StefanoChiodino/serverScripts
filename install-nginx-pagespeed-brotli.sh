# !IMPORTANT: remove pre-existing nginx if present. ALso check if the versions are up to date.

NPS_VERSION=1.11.33.2
# Check http://nginx.org/en/download.html for the latest version.
NGINX_VERSION=1.10.0

# BROTLI
# Use Google brotli module,
# alternatively you can use cloudflare one https://github.com/cloudflare/ngx_brotli_module .
cd
git clone https://github.com/google/ngx_brotli.git

# PAGESPEED
cd
wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -O release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz  # extracts to psol/

cd
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --with-cc-opt='-g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' --with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now' --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_addition_module --with-http_dav_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_sub_module --with-http_xslt_module --with-stream --with-stream_ssl_module --with-mail --with-mail_ssl_module --with-threads  --with-http_v2_module --add-module=~/ngx_pagespeed-release-${NPS_VERSION}-beta --add-module=~/ngx_brotli --sbin-path=/usr/sbin/nginx
sudo make
sudo make install

# Cleanup.
cd
rm -rf ngx_brotli ngx_pagespeed-release-${NPS_VERSION}-beta/ nginx-${NGINX_VERSION}/ 


# Other modules that were installed by default.
#--add-module=/build/nginx-JLELmI/nginx-1.10.0/debian/modules/nginx-auth-pam --add-module=/build/nginx-JLELmI/nginx-1.10.0/debian/modules/nginx-dav-ext-module --add-module=/build/nginx-JLELmI/nginx-1.10.0/debian/modules/nginx-echo --add-module=/build/nginx-JLELmI/nginx-1.10.0/debian/modules/nginx-upstream-fair --add-module=/build/nginx-JLELmI/nginx-1.10.0/debian/modules/ngx_http_substitutions_filter_module 