# Download base image ubuntu 18.04
# Written by lanmower

FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install dialog apt-utils debconf -y -q
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get install git rcs make makepasswd cpanminus libauthen-ntlm-perl \ 
     libclass-load-perl libcrypt-ssleay-perl liburi-perl \
     libdata-uniqid-perl libdigest-hmac-perl libdist-checkconflicts-perl \
     libfile-copy-recursive-perl libio-compress-perl libio-socket-inet6-perl \
     libio-socket-ssl-perl libio-tee-perl libmail-imapclient-perl \
     libmodule-scandeps-perl libnet-ssleay-perl libpar-packer-perl \
     libreadonly-perl libsys-meminfo-perl libterm-readkey-perl \
     libtest-fatal-perl libtest-mock-guard-perl libtest-pod-perl \
     libtest-requires-perl libtest-simple-perl libcrypt-openssl-rsa-perl libcrypt-openssl-random-perl perl-openssl-defaults -y -q
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get install libio-tee-perl -y -q
RUN apt-get install libunicode-string-perl -y -q
RUN apt-get install libssl-dev -y -q

RUN cpanm Mail::IMAPClient JSON::WebToken Test::MockObject --force

RUN cpanm Unicode::String Data::Uniqid --force 2>/dev/null || exit 0

RUN cpanm File::Tail CGI Crypt::OpenSSL::RSA JSON JSON::WebToken JSON::WebToken::Crypt::RSA LWP::UserAgent Regexp::Common Test::MockObject Test::Deep --force

RUN git clone https://github.com/imapsync/imapsync.git

RUN cd imapsync && make install

RUN cd imapsync && echo ./imapsync --host1 imap.gmail.com --user1 $1 --password1 $2 --prefix2 '['$1']' --host2 imap.gmail.com --user2 $3 --password2 $4 --syncinternaldates --ssl1 -ssl2 --noauthmd5 --split1 100 --split2 100 --port1 993 --port2 993 --allowsizemismatch > usertransfer

CMD cd imapsync && ./usertransfer $from $frompass $to $topass

