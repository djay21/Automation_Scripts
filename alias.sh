wget https://raw.githubusercontent.com/djay21/Automation_Scripts/master/alias.txt
# sudo usermod -aG docker $USER
# systemctl daemon-reload
# systemctl restart docker
sed -i '/^alias/d' ~/.bashrc
sed -i "/^HISTTIMEFORMAT/g" ~/.bashrc
sed -i "/^function/g" ~/.bashrc
cat alias.txt >> ~/.bashrc
source ~/.bashrc
rm -rf alias.txt
