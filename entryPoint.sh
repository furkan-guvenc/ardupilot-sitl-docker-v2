#! /bin/bash
echo SYSID_THISMAV=$1 | tee -a /ardupilot/Tools/autotest/default_params/copter.parm
cat /external/extra-locations.txt >> /ardupilot/Tools/autotest/locations.txt
START_LOCATION=$(< /external/start-location.conf)
sim_vehicle.py -N -v ArduCopter -L $START_LOCATION $SIM_OPTIONS
