#!/bin/bash
set -e

# --- Variables (set these as needed) ---
REPO_NAME="test"
DOMAIN="srm-tech.com"
S3_BUCKET_NAME="srm-deployment-files"
AWS_REGION="ap-south-1"
REPO_URL="https://git-codecommit.ap-south-1.amazonaws.com/v1/repos/$REPO_NAME"

# --- System prep ---
apt update -y && apt upgrade -y
apt install -y python3 python3-pip git nginx certbot python3-certbot-nginx docker.io docker-compose unzip jq awscli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip
sudo ./aws/install

git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

# --- Clone repo ---
git clone "$REPO_URL" -b master /home/ubuntu/$REPO_NAME || true
cd /home/ubuntu/$REPO_NAME

# --- Get secrets (if needed) ---
# aws secretsmanager get-secret-value ... > .env
# cp .env backend/.env

# --- Docker compose up ---
docker-compose up -d

# --- Nginx config ---
cp certs/frontend.conf /etc/nginx/sites-available/$REPO_NAME-app.$DOMAIN
cp certs/backend.conf /etc/nginx/sites-available/$REPO_NAME-backend.$DOMAIN
ln -sf /etc/nginx/sites-available/$REPO_NAME-app.$DOMAIN /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/$REPO_NAME-backend.$DOMAIN /etc/nginx/sites-enabled/

# --- Download SSL certs from S3 ---
mkdir -p /etc/letsencrypt/archive/$REPO_NAME-app.$DOMAIN
mkdir -p /etc/letsencrypt/archive/$REPO_NAME-backend.$DOMAIN

aws s3 cp s3://$S3_BUCKET_NAME/certificates/$REPO_NAME/$REPO_NAME-app.$DOMAIN/fullchain.pem /etc/letsencrypt/archive/$REPO_NAME-app.$DOMAIN/fullchain1.pem --region $AWS_REGION
aws s3 cp s3://$S3_BUCKET_NAME/certificates/$REPO_NAME/$REPO_NAME-app.$DOMAIN/privkey.pem /etc/letsencrypt/archive/$REPO_NAME-app.$DOMAIN/privkey1.pem --region $AWS_REGION
aws s3 cp s3://$S3_BUCKET_NAME/certificates/$REPO_NAME/$REPO_NAME-backend.$DOMAIN/fullchain.pem /etc/letsencrypt/archive/$REPO_NAME-backend.$DOMAIN/fullchain1.pem --region $AWS_REGION
aws s3 cp s3://$S3_BUCKET_NAME/certificates/$REPO_NAME/$REPO_NAME-backend.$DOMAIN/privkey.pem /etc/letsencrypt/archive/$REPO_NAME-backend.$DOMAIN/privkey1.pem --region $AWS_REGION

# --- Create /etc/letsencrypt/live/ symlinks ---
mkdir -p /etc/letsencrypt/live/$REPO_NAME-app.$DOMAIN
mkdir -p /etc/letsencrypt/live/$REPO_NAME-backend.$DOMAIN

ln -sf /etc/letsencrypt/archive/$REPO_NAME-app.$DOMAIN/fullchain1.pem /etc/letsencrypt/live/$REPO_NAME-app.$DOMAIN/fullchain.pem
ln -sf /etc/letsencrypt/archive/$REPO_NAME-app.$DOMAIN/privkey1.pem /etc/letsencrypt/live/$REPO_NAME-app.$DOMAIN/privkey.pem
ln -sf /etc/letsencrypt/archive/$REPO_NAME-backend.$DOMAIN/fullchain1.pem /etc/letsencrypt/live/$REPO_NAME-backend.$DOMAIN/fullchain.pem
ln -sf /etc/letsencrypt/archive/$REPO_NAME-backend.$DOMAIN/privkey1.pem /etc/letsencrypt/live/$REPO_NAME-backend.$DOMAIN/privkey.pem

chown -R root:root /etc/letsencrypt
chmod -R 755 /etc/letsencrypt

# --- Reload nginx ---
nginx -t && systemctl reload nginx