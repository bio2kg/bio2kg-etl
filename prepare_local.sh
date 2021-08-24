
echo "Downloading rmlmapper.jar in /opt"
curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

echo "Installing YARRRML parser"
yarn global add @rmlio/yarrrml-parser

echo "Installing ShEx"
yarn --cwd /opt add shex

echo "Installing RocketRML"
yarn

python3 -m venv .venv

echo "Install dependencies for python scripts"
pip3 install -r workflows/requirements.txt
# conda install --file workflows/requirements.txt

# Additional packages you might need to install
# conda install --quiet -y wget unzip
