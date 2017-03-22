##!/bin/bash
if [ -z "$2" ]
  then
    echo "Arguments supplied not complete. Please provide the NSX release and build number."
    echo "Syntax: ./nsx-sdn-lab-upgrade 6.2.4 4567890"
    exit 1
fi
echo ""
echo "███╗   ██╗███████╗██╗  ██╗    ███████╗██████╗ ███╗   ██╗      ██╗      █████╗ ██████╗     ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗ ██████╗ ███████╗"
echo "████╗  ██║██╔════╝╚██╗██╔╝    ██╔════╝██╔══██╗████╗  ██║      ██║     ██╔══██╗██╔══██╗    ██║   ██║██╔══██╗██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝"
echo "██╔██╗ ██║███████╗ ╚███╔╝     ███████╗██║  ██║██╔██╗ ██║█████╗██║     ███████║██████╔╝    ██║   ██║██████╔╝██║  ███╗██████╔╝███████║██║  ██║█████╗  "
echo "██║╚██╗██║╚════██║ ██╔██╗     ╚════██║██║  ██║██║╚██╗██║╚════╝██║     ██╔══██║██╔══██╗    ██║   ██║██╔═══╝ ██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  "
echo "██║ ╚████║███████║██╔╝ ██╗    ███████║██████╔╝██║ ╚████║      ███████╗██║  ██║██████╔╝    ╚██████╔╝██║     ╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗"
echo "╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝    ╚══════╝╚═════╝ ╚═╝  ╚═══╝      ╚══════╝╚═╝  ╚═╝╚═════╝      ╚═════╝ ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝"
echo ""
echo "╔══════════════════════════╗"
echo "║- Author: Hany Michael    ║"
echo "║- eMail: hany@vmware.com  ║"
echo "║- Version: 1.0            ║"
echo "╚══════════════════════════╝"
echo ""
echo ""
# NSX Manager of Site 01
nsxManagerSite01_host="nsxmgr01.core.hypervizor.com"
nsxManagerSite01_user="admin"
nsxManagerSite01_pass="VMware1!"
# NSX Manager of Site 02
nsxManagerSite02_host="nsxmgr02.core.hypervizor.com"
nsxManagerSite02_user="admin"
nsxManagerSite02_pass="VMware1!"
# NSX Buildweb URL
nsxBuildweb_URL="http://URL/"


echo "╔══════════════════════════"
echo "║ NSX Release: $1          "
echo "║ NSX Build: $2            "
echo "╚══════════════════════════"
echo ""
echo ""'Buildweb upgrade bundle URL: '$nsxBuildweb_URL'VMware-NSX-Manager-upgrade-bundle-$1-$2.tar.gz'""

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Downloading the Upgrade Bundle                        ║"
echo "╚═══════════════════════════════════════════════════════╝"
wget $nsxBuildweb_URL'VMware-NSX-Manager-upgrade-bundle-'$1-$2'.tar.gz'

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Renaming the upgrade bundle to upgrade-bundle.tar.gz  ║"
echo "╚═══════════════════════════════════════════════════════╝"
mv VMware-NSX-Manager-upgrade-bundle-$1-$2.tar.gz upgrade-bundle.tar.gz

echo "╔═════════════════════════════════════════════════════════════════════╗"
echo "║ Uploading the upgade package to the NSX Manager in Cairo Datacenter ║"
echo "╚═════════════════════════════════════════════════════════════════════╝"
curl -i -v -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -H 'Accept:application/xml' -F file=@upgrade-bundle.tar.gz -X POST https://$nsxManagerSite01_host/api/1.0/appliance-management/upgrade/uploadbundle/NSX -o upload.out

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading NSX Manager in Cairo Datacenter             ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" -d '<preUpgradeQuestionsAnswers><preUpgradeQuestionAnswer><questionId>preUpgradeChecks1:Q1</questionId><question>Do you want to enable SSH?</question> <questionAnserType>YESNO</questionAnserType><answer>YES</answer></preUpgradeQuestionAnswer></preUpgradeQuestionsAnswers>' "https://$nsxManagerSite01_host/api/1.0/appliance-management/upgrade/start/NSX"

echo "╔═════════════════════════════════════════════════════════════════════╗"
echo "║ Uploading Package to secondary NSX Manager in Alexandria Datacenter ║"
echo "╚═════════════════════════════════════════════════════════════════════╝"
curl -i -v -k -u $nsxManagerSite02_user:$nsxManagerSite01_pass -H 'Accept:application/xml' -F file=@upgrade-bundle.tar.gz -X POST https://$nsxManagerSite02_host/api/1.0/appliance-management/upgrade/uploadbundle/NSX -o upload.out

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading NSX Manager in Alexandria Datacenter        ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -k -u $nsxManagerSite02_user:$nsxManagerSite02_pass -X POST -H "Content-Type: application/xml" -d '<preUpgradeQuestionsAnswers><preUpgradeQuestionAnswer><questionId>preUpgradeChecks1:Q1</questionId><question>Do you want to enable SSH?</question> <questionAnserType>YESNO</questionAnserType><answer>YES</answer></preUpgradeQuestionAnswer></preUpgradeQuestionsAnswers>' "https://$nsxManagerSite02_host/api/1.0/appliance-management/upgrade/start/NSX"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Sleeping for 10 minutes                               ║"
echo "╚═══════════════════════════════════════════════════════╝"
sleep 10m

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading Controller Cluster in Cairo Datacenter      ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -i -v -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -H 'Accept:application/xml' -X POST https://$nsxManagerSite01_host/api/2.0/vdn/controller/cluster/upgrade

echo "╔═══════════════════════════════════════════════════════════════════════════╗"
echo "║ Sleeping for 70 minutes until the controller cluster finishes the upgrade ║"
echo "╚═══════════════════════════════════════════════════════════════════════════╝"
sleep 70m

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading Compute Cluster in Cairo Datacenter         ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X PUT -H "Content-Type: application/xml" -d '<nwFabricFeatureConfig><resourceConfig><resourceId>domain-c7</resourceId></resourceConfig></nwFabricFeatureConfig>' "https://$nsxManagerSite01_host/api/2.0/nwfabric/configure"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading Edge Cluster in Cairo Datacenter            ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X PUT -H "Content-Type: application/xml" -d '<nwFabricFeatureConfig><resourceConfig><resourceId>domain-c253</resourceId></resourceConfig></nwFabricFeatureConfig>' "https://$nsxManagerSite01_host/api/2.0/nwfabric/configure"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading Compute Cluster in Alexandria Datacenter    ║"
echo "╚═══════════════════════════════════════════════════════╝"
curl -k -u $nsxManagerSite02_user:$nsxManagerSite02_pass -X PUT -H "Content-Type: application/xml" -d '<nwFabricFeatureConfig><resourceConfig><resourceId>domain-c7</resourceId></resourceConfig></nwFabricFeatureConfig>' "https://$nsxManagerSite02_host/api/2.0/nwfabric/configure"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading the ESGs in Cairo Datacenter                ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "Upgrading UDLR"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-a9cd7497-f0dc-455b-945d-ac47639cf17e?action=upgrade"
echo "Upgrading edge-1"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-1?action=upgrade"
echo "Upgrading edge-2"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-2?action=upgrade"
echo "Upgrading edge-17"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-17?action=upgrade"
echo "Upgrading edge-19"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-19?action=upgrade"
echo "Upgrading edge-22"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-22?action=upgrade"
echo "Upgrading edge-23"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-23?action=upgrade"
echo "Upgrading edge-24"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-24?action=upgrade"
echo "Upgrading edge-25"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-25?action=upgrade"
echo "Upgrading edge-26"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-26?action=upgrade"
echo "Upgrading edge-32"
curl -k -u $nsxManagerSite01_user:$nsxManagerSite01_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite01_host/api/4.0/edges/edge-32?action=upgrade"

echo "╔═══════════════════════════════════════════════════════╗"
echo "║ Upgrading the ESGs in Alexandria Datacenter           ║"
echo "╚═══════════════════════════════════════════════════════╝"
echo "Upgrading edge-1"
curl -k -u $nsxManagerSite02_user:$nsxManagerSite02_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite02_host/api/4.0/edges/edge-1?action=upgrade"
echo "Upgrading edge-2"
curl -k -u $nsxManagerSite02_user:$nsxManagerSite02_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite02_host/api/4.0/edges/edge-2?action=upgrade"
echo "Upgrading edge-4"
curl -k -u $nsxManagerSite02_user:$nsxManagerSite02_pass -X POST -H "Content-Type: application/xml" "https://$nsxManagerSite02_host/api/4.0/edges/edge-4?action=upgrade"

echo "▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄       ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄  "
echo "▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░▌"
echo "▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌     ▐░▌▐░█▀▀▀▀▀▀▀█░▌"
echo "    ▐░▌     ▐░▌       ▐░▌▐░▌               ▐░▌          ▐░▌▐░▌    ▐░▌▐░▌       ▐░▌"
echo "    ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▌   ▐░▌▐░▌       ▐░▌"
echo "    ▐░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌▐░▌       ▐░▌"
echo "    ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▐░▌ ▐░▌▐░▌       ▐░▌"
echo "    ▐░▌     ▐░▌       ▐░▌▐░▌               ▐░▌          ▐░▌    ▐░▌▐░▌▐░▌       ▐░▌"
echo "    ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░▐░▌▐░█▄▄▄▄▄▄▄█░▌"
echo "    ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░▌ "
echo "     ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀  "
