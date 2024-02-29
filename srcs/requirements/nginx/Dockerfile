FROM debian:bullseye

LABEL author="isadri"

# our application will use the port 443
EXPOSE 443

# set /app as the working directory of the container
WORKDIR /app

# install dependencies
RUN apt-get update ; apt-get install --no-install-recommends -y nginx vim \
	openssl iputils-ping

# create the certificate and generate the private key
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/CN=${DOMAIN_NAME}"

# openssl:	This is the basic command line tool for creating and managing OpenSSL certificates,
# 			keys, and other files.
# req:	specifies which certicate we want to use.
# -x509:	specifies that we want to make a self-signed certificate.
# -nodes:	skip the option to secure our certificate with a passphrase.
# -days 365:	sets the length of time that the certificate will be considered valid.
# -newkey rsa:2048:	generate a new certificate and a new key at the same time.
#					And the rsa:2048 portion make an RSA key that is 2048 bits long.
# -keyout:	where to place the generated private key file.
# -out:	where to place the certificate.
# -subj: fill the common name option by ${DOMAIN_NAME}

# copy nginx configuration to the container
COPY conf/nginx.conf /etc/nginx/conf.d/

# run nginx in the foreground
CMD [ "nginx", "-g", "daemon off;" ]
