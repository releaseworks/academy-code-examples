## Creating the infrastructure

Before you start using this Terraform configuration make sure you have an SSH key pair configured in EC2. If you name it `releaseworks-academy` you will not have to edit the terraform configuration.

Run Terraform init to download the required modules and providers:
```
terraform init
```

Run Terraform plan to see what will be created
```
terraform plan
```

If you are happy with the output run Terraform apply:
```
terraform apply
```

## Installing Wordpress on EC2

Log into your instance using your public key with:
```
ssh ubuntu@$YOUR_PUBLIC_IP_ADDRESS
```
replacing $YOUR_PUBLIC_IP_ADDRESS with the public ip address of your EC2 instance.

Install Wordpress's dependencies:
```
sudo apt update
sudo apt install nginx php-fpm php-mysql
```

Configure nginx by editing `/etc/nginx/sites-available/wordpress` so it looks like
```
server {
        listen 80;
        listen [::]:80;

        root /var/www/wordpress;

        index index.php;

        server_name $YOUR_PUBLIC_IP_ADDRESS;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        }
}
```
Replacing $YOUR_PUBLIC_IP_ADDRESS with the public address of your EC2 instance.

Apply the config with:
```
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
sudo systemctl restart nginx
```

Download and install Wordpress:
```
wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz
sudo tar -xzvf /tmp/wordpress.tar.gz -C /var/www
sudo chown -R www-data:www-data /var/www/wordpress
```

Open a browser using the public ip address of your instance as the url and follow the Wordpress installer instructions. Use the login details from the terraform configuration and the endpoint of your RDS instance to configure the database connection.

## Removing your infrastructure
Simply run
```
terraform destory
```
