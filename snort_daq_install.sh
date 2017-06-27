
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


echo "##################################################################"
echo "# setting  /etc/snort/snort.conf                                 #"
echo "##################################################################"

sed -i 's/include \$RULE\_PATH/\#include \$RULE\_PATH/' /etc/snort/snort.conf
sed -i 's/\#include \$RULE_PATH\/local\.rules/\include \$RULE_PATH\/local\.rules/' /etc/snort/snort.conf

sed -i 's/var RULE_PATH \.\.\/rules/var RULE_PATH \/etc\/snort\/rules/' /etc/snort/snort.conf
sed -i 's/var SO_RULE_PATH \.\.\/so_rules/var SO_RULE_PATH \/etc\/snort\/so_rules/' /etc/snort/snort.conf
sed -i 's/var PREPROC_RULE_PATH \.\.\/preproc_rules/var PREPROC_RULE_PATH \/etc\/snort\/preproc_rules/' /etc/snort/snort.conf
sed -i 's/var WHITE_LIST_PATH \.\.\/rules/var WHITE_LIST_PATH \/etc\/snort\/rules\/white_list.rules/' /etc/snort/snort.conf
sed -i 's/var BLACK_LIST_PATH \.\.\/rules/var BLACK_LIST_PATH \/etc\/snort\/rules\/black_list.rules/' /etc/snort/snort.conf

sed -i 's/whitelist \$WHITE_LIST_PATH\/white_list\.rules\, /\#whitelist \$WHITE_LIST_PATH\/white_list\.rules\,/' /etc/snort/snort.conf
sed -i 's/blacklist \$BLACK_LIST_PATH\/black_list\.rules/#blacklist \$BLACK_LIST_PATH\/black_list\.rules/' /etc/snort/snort.conf



echo "##################################################################"
echo "# Modify /etc/apache2/mods-enabled/dir.conf -> index.php enable  #"
echo "##################################################################"
