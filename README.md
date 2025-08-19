### CloudlogBashCat

A simple script to keep Cloudlog in synch with rigctld or flrig

* Edit the config file - instructions contained within!
* Run it with ``./cloudlogbashcat.sh``

### Run as a systemd service

To run this process in the background on bootup, we can install
is as a systemd service. Note that you'll need to update the
service file to point to the correct directory. Once you've
done this, install by:

```bash
# Create a symlink to the service file. This will allow git to update the service file later
cd CloudlogBashCat
sudo ln -s $(pwd)/cloudlogbashcat.service /etc/systemd/system/cloudlogbashcat.service

# Reload the systemctl daemon
sudo systemctl daemon-reload

# Enable and start the new service
sudo systemctl enable --now cloudlogbashcat
```
