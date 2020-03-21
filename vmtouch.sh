set -e
cd /tmp/
git clone https://github.com/hoytech/vmtouch.git
cd vmtouch
make
make install
cd
rm -rf /tmp/vmtouch
