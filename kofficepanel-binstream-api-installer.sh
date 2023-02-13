echo "kOfficePanel Binstream API - INSTALLER"
echo ""

TOKEN="$1"

if [ -z "$TOKEN" ]
then
	echo "Token can't be empty!"
	echo ""
	exit 1
fi

echo "Installing NPM..."
echo ""
curl –sL --silent "https://rpm.nodesource.com/setup_16.x" | sudo bash - &> /dev/null
yes | yum install –y npm &> /dev/null

echo "Installing PM2.."
echo ""
npm install -g pm2 &> /dev/null

echo "Downloading kOfficePanel Binstream API..."
echo ""
mkdir /home/kofficepanel-binstream-api/ &> /dev/null
curl -sL --silent "https://github.com/Krash0/kofficepanel-binstream-api-public/raw/master/kofficepanel-binstream-api-linux" --output /home/kofficepanel-binstream-api/kofficepanel-binstream-api-linux
curl -sL --silent "https://raw.githubusercontent.com/Krash0/kofficepanel-binstream-api-public/master/default_config.json" --output /home/kofficepanel-binstream-api/config.json
sed -i "s/{TOKEN}/$TOKEN/g" /home/kofficepanel-binstream-api/config.json
chmod -R 770 /home/kofficepanel-binstream-api/ &> /dev/null

echo "Starting kOfficePanel Binstream API..."
echo ""
cd /home/kofficepanel-binstream-api/ && /usr/local/bin/pm2 start kofficepanel-binstream-api-linux &> /dev/null
/usr/local/bin/pm2 startup &> /dev/null
/usr/local/bin/pm2 save &> /dev/null

RESULT=$(ps aux|grep kofficepanel-binstream-api|grep -v 'grep')

if [[ "$RESULT" == *"kofficepanel"* ]]; then
	echo "kOfficePanel Binstream API installed!"
else
	echo "kOfficePanel Binstream API can't be installed!"
	echo "Manually download from github."
fi