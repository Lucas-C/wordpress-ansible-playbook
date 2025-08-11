# Upgrading to a newer PHP fpm version
Requirement: `/etc/apt/sources.list.d/ppa_ondrej_php_*.list` exists / installed.

```bash
version=8.4
# Install PHP
apt update && apt install -y php${version}-fpm php${version} php${version}-cli php${version}-common php${version}-curl php${version}-dev php${version}-fpm php${version}-gd php${version}-mbstring php${version}-mysql php${version}-opcache php${version}-xml php${version}-xmlrpc php${version}-zip
# Set PHP user
sed -i "s/user = .*/user = web/" /etc/php/${version}/fpm/pool.d/www.conf
# Set PHP group & listen group
sed -i "s/group = .*/group = web/" /etc/php/${version}/fpm/pool.d/www.conf
# Set PHP listen owner
sed -i "s/listen.owner = .*/listen.owner = web/" /etc/php/${version}/fpm/pool.d/www.conf
# Set PHP upload max filesize
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 128M/" /etc/php/${version}/fpm/php.ini
# Set PHP post max filesize
sed -i "s/post_max_size = .*/post_max_size = 128M/" /etc/php/${version}/fpm/php.ini
# Create a PHP upstream for NGINX
cat >/etc/nginx/upstreams/php${version}.conf <<EOF
upstream php${version} {
    server unix:/run/php/php${version}-fpm.sock;
}
EOF
# Set the PHP upstream for NGINX
sed -i "s/php[0-9.]\+/php${version}/" /etc/nginx/global/php-pool.conf /etc/nginx/sites-available/*
service php${version}-fpm restart && service nginx reload

# Cleanup: remove old version
version=8.1
apt remove -y php${version}-fpm php${version} php${version}-cli php${version}-common php${version}-curl php${version}-dev php${version}-fpm php${version}-gd php${version}-mbstring php${version}-mysql php${version}-opcache php${version}-xml php${version}-xmlrpc php${version}-zip
```
