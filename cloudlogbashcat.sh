#! /bin/bash

# cloudlogbashcat.sh - A simple script to keep Cloudlog in synch with rigctld
# Copyright (C) 2018  Tony Corbett, G0WFV
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

DEBUG=0

rigctldFreq=0
rigctldOldFreq=1

rigctldMode="MATCH"
rigctldOldMode="NO MATCH"

delay=1

source cloudlogbashcat.conf

# Open FD 3 to rigctld ...
exec 3<>/dev/tcp/$rigctldHost/$rigctldPort

while true; do
	# Get rigctld frequency, mode and bandwidth - accepts multiple commands
	echo -e "fm" >&3
	read -r -u3 rigctldFreq
	read -r -u3 rigctldMode
	read -r -u3 rigctldWidth
		
  if [ $rigctldFreq -ne $rigctldOldFreq  ] || [ "$rigctldMode" != "$rigctldOldMode"  ]; then
    # rigctld freq or mode changed, update Cloudlog
    [[ $DEBUG -eq 1 ]] && printf  "%-10d   %-6s\n" $rigctldFreq $rigctldMode
    rigctldOldFreq=$rigctldFreq
    rigctldOldMode=$rigctldMode

    curl --silent --insecure \
         --header "Content-Type: application/json" \
         --request POST \
         --data "{ 
           \"key\":\"$cloudlogApiKey\",
           \"radio\":\"$cloudlogRadioId\",
           \"frequency\":\"$rigctldFreq\",
           \"mode\":\"$rigctldMode\",
           \"timestamp\":\"$(date +"%Y/%m/%d %H:%M")\"
         }" $cloudlogApiUrl >/dev/null 2>&1
  fi

	sleep $delay
done

