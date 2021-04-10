
#########################################################################
#	Centos7-Base-Webtoon Container Image				#
#	https://github.com/krsuhjunho/centos7-base-webtoon		#
#	BASE IMAGE: ghcr.io/krsuhjunho/centos7-base-systemd		#
#########################################################################

FROM ghcr.io/krsuhjunho/centos7-base-systemd

#########################################################################
#	Install && Update 						#
#########################################################################

RUN yum install -y -q httpd \
	systemctl enable httpd;\
	yum clean all



# Install EPEL Repo
RUN  rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Install PHP
RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip php-curl php-fpm php-gmp php-json php-sqlite3 php-bz2 zip unzip  

# Update Apache Configuration
RUN sed -E -i -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf



#########################################################################
#	HEALTHCHECK 							#
#########################################################################

HEALTHCHECK --interval=60s --timeout=60s --start-period=60s --retries=3 CMD curl -f http://127.0.0.1/ || exit 1

#########################################################################
#	WORKDIR SETUP 							#
#########################################################################

WORKDIR /var/www

#########################################################################
#	PORT OPEN							#
#	SSH PORT 22 							#
#  	HTTP PORT 80 							#
#########################################################################

EXPOSE 80


#########################################################################
#       Systemd		 	                                        #
#########################################################################
# Start Apache
CMD ["/usr/sbin/init"]
