
DAQ_VER=2.0.6
SNORT_VER=2.9.9.0


wget https://www.snort.org/downloads/snort/daq-$(DAQ_VER).tar.gz
wget https://www.snort.org/downloads/snort/snort-$(SNORT_VER).tar.gz

tar vfxz daq-$(DAQ_VER).tar.gz
cd daq-$(DAQ_VER)
./configure
make
make install
cd -

tar vfxz snort-$(SNORT_VER).tar.gz
cd snort-$(SNORT_VER)
# packet performance monitoring (PPM)
./configure --enable-sourcefire
make
make install
cd -

ldconfig

ln -s /usr/local/bin/snort /usr/sbin/snort
snort -V

mkdir /etc/snort
mkdir /etc/snort/rules
mkdir /etc/snort/preproc_rules

touch /etc/snort/rules/white_list.rules
touch /etc/snort/rules/black_list.rules
touch /etc/snort/rules/local.rules

mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules

chmod -R 5775 /etc/snort
chmod -R 5775 /var/log/snort
chmod -R 5775 /usr/local/lib/snort
chmod -R 5775 /usr/local/lib/snort_dynamicrules

cp snort-$(SNORT_VER)/etc/*.conf* /etc/snort/
cp snort-$(SNORT_VER)/etc/*.map* /etc/snort/
cp /etc/snort/snort.conf /etc/snort/snort.conf_orig


sed -i 's/include \$RULE\_PATH/\#include \$RULE\_PATH/' /etc/snort/snort.conf

