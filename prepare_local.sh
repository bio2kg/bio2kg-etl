
echo "Downloading rmlmapper.jar in /opt"
curl -s https://api.github.com/repos/RMLio/rmlmapper-java/releases/latest \
    | grep browser_download_url | grep .jar | cut -d '"' -f 4 \
    | wget -O /opt/rmlmapper.jar -qi -

echo "Installing YARRRML parser"
yarn global add @rmlio/yarrrml-parser

echo "Installing ShEx"
yarn --cwd /opt add shex

echo "Installing RocketRML"
npm install -g rocketrml

echo "Install dependencies for python scripts"
conda install --file requirements.txt
# or use pip install -r requirements.txt

# Additional packages to install
# conda install --quiet -y wget unzip

echo "Retrieving IDS RML functions files"
cp ../ids-rml-functions/functions_ids.ttl datasets/
cp ../ids-rml-functions/target/IdsRmlFunctions-v0.0.1-jar-with-dependencies.jar datasets/IdsRmlFunctions.jar