

echo "Installing package.json (for RocketRML)"
yarn

# echo "Install dependencies for python scripts"
# pip install -r requirements.txt
# conda install --file requirements.txt

if [ ! -f "d2s-cli" ]; then
    echo "Clone d2s-cli"
    git clone https://github.com/MaastrichtU-IDS/d2s-cli
fi

echo "Install d2s-cli"
pip install -e ./d2s-cli

# start-notebook.sh