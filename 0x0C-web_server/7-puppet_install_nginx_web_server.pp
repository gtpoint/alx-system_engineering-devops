# Install Nginx package
package { 'nginx':
  ensure => 'installed',
}

# Ensure Nginx service is running and enabled at boot
service { 'nginx':
  ensure => 'running',
  enable => true,
  require => Package['nginx'],
}

# Create an Nginx server block configuration
file { '/etc/nginx/sites-available/default':
  ensure => 'present',
  content => "
server {
    listen 80;
    server_name _;

    location / {
        return 301 https://$host$request_uri;
    }

    location /redirect_me {
        return 301 https://$host/hello;
    }

    location /hello {
        return 200 'Hello World!';
    }
}
  ",
  notify => Service['nginx'],
  require => Package['nginx'],
}

# Enable the default server block by creating a symbolic link
file { '/etc/nginx/sites-enabled/default':
  ensure => 'link',
  target => '/etc/nginx/sites-available/default',
  notify => Service['nginx'],
  require => File['/etc/nginx/sites-available/default'],
}
