set -e
wget https://github.com/bazelbuild/bazel/releases/download/1.1.0/bazel-1.1.0-installer-linux-x86_64.sh
bash bazel-*-installer-linux-x86_64.sh --user
rm bazel-*-installer-linux-x86_64.sh
export PATH="$PATH:$HOME/bin"
bazel --help
cd /tmp
git clone https://github.com/tensorflow/addons.git
cd addons
python ./configure.py --no-deps
bazel build --nobuild -- //tensorflow_addons/...
cd ..
rm -rf ./addons
