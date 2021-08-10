# Overview
This is the Xpert Services Cloud and Automation Practice **starter** offering blueprints repository.

Note that this repository contains exclusively content required to deploy blueprints.
All other documents (kickoff powerpoint presentation, datasheets, etc...) are stored in the [cita-starter Sharepoint folder](https://ntnx.tech/cita-starter).

This repository contains the following blueprints:
- **Windows** (based on Windows Server 2019)
- **Linux** (based on CentOS 7)

Each blueprint has the following flavors:
- **Static IP** addressing: where IPv4 configuration is captured from the user at launch time.
- **DHCP**: where IPv4 configuration is assumed to be obtained automatically.
- **IPAM-phpIPAM**: where the IPv4 configuration is drawn from a phpIPAM server instance and injected as a static IPv4 configuration in the VM.
- **IPAM-infoblox**: where the IPv4 configuration is drawn from an Infoblox IPAM server instance and injected as a static IPv4 configuration in the VM.
- **IPAM-solarwinds**: where the IPv4 configuration is drawn from a Solarwinds IPAM server instance and injected as a static IPv4 configuration in the VM.

Each blueprint has the following application profiles:
- **AHV**
- **vSphere**

Note that all the escripts and in-guest scripts used in the blueprints here are maintained in the [tasklib](https://ntnx.tech/cita-tasklib) repository.

# Instructions for Deployment
In order to deploy one or more of those blueprints in a client environment, you will need to:
1. **Enable Calm** in the client Prism Central
2. **Configure** AHV and vSphere **providers** in Calm (either or both depending on the client requirements)
3. **Create** a **Calm project** which is authorized for AHV and vSphere clusters/providers and has default environments configured for Windows and Linux on each provider
4. **Clone** this **git repository** to a workstation which has access to the client Calm/Prism Central instance and has calm-dsl installed.
	`git clone https://github.com/nutanixservices/cita-starter` && `cd cita-starter`
5. **Review `make help` to see the various options that can be executed via make commands.
6. **Initialize the local secrets** by running `make init-dsl` to add credential files in a .local directory at the root of the repo to enable blueprint compiling.  The `dsl-init-secrets.sh` file, which is called from the Make command, can be edited to include proper passwords as needed.  Supply your username and password for the Calm instance IP that you entered during the initial cookiecutter.
7. Figure out the following **AHV information**:
	- Name of the **Windows** Server 2019 **template** disk image (which must be sysprep ready)
	- Name of the **CentOS 7** cloud **disk image** (which must be cloud-init ready)
	- Name of the default **AHV network** to use for Windows and Linux VMs
    - Name of the **AHV cluster** to deploy to
8. Figure out the following **vSphere information**:
	- Id of the vCenter **VM template for Windows** Server 2019 (does not need to be sysprep ready)
	- Id of the vCenter **VM template for CentOS7** (which must be cloud-init ready and NOT have any cdrom drive as one will be added automatically during provisioning)
	- Name of the **vCenter datacenter**, HA/DRS cluster and **datastore** cluster to use
	- Name of the **network portgroup** to use for Windows and Linux VMs
9. Figure out the following **additional information**:
    - Name of the **Active Directory domain** to use for Windows VMs
	- If you are using static IP addresses, the **IPv4 configuration** information: subnet mask, default gateway and DNS servers to use
	- **SMTP gateway IP** address and default **sender email** address for email notifications
10. **Create the Cookiecutter blueprints on the Calm instances by running one of the make create blocks, e.g., `make create-linux-ipam-bp` or `make create-windows-ipam-bp`**
11. **Customize the blueprints** as required by the client.
12. Use calm-dsl to **compile each blueprint** the client requires.
13. **Test** each blueprint.
14. **Publish** each blueprint in the Calm marketplace.

The sections below will provide detailed instructions for each one of those steps.
If this is the first time you use a Cloud & Automation Calm repository, you will want to read the following documents first:
- Setting up a workstation for calm-dsl based development
- Understanding the structure of calm-dsl decompiled blueprints

# Requirements
## phpipam
1. In phpIPAM > Server Management > phpIPAM Settings > Feature Settings > API must be turned **ON** (default is **OFF**)
2. Create an application in phpIPAM > Server Management > API (use "SSL with user token" for security and "read/write" for access; make a note of the app id)
## infoblox
1. The default gateway and dns servers have been defined on the network
## solarwinds
1. A Calm endpoint called solarwinds has been defined with the proper credentials in Calm that points to the SolarWinds IPAM Windows server
2. Remote PowerShell has been configured and enabled on the SolarWinds IPAM Windows server
# Troubleshooting

> *vSphere Linux blueprint does not boot correctly with "**dracut-initqueue timeout**" errors displayed on the VM console*

This is usually caused by an **incorrect vSphere spec yaml file**. You may reference incorrect template disks or controllers, or have an incorrect size for one of those disks.
The easiest way to troubleshoot this is to compile the blueprint into Calm, edit the blueprint in the UI and change something in the vSphere VM specification, then save the blueprint and export it as json.  Now decompile it with calm-dsl and compare the vSphere spec file to quickly see the differences.

> *Virtual machine does not get the correct static IP*

This is usually caused by an **insufficient delay** before the check login task on the substrate definition.  Increase the delay to allow guest customization to complete.

> *Getting error 500 when trying to create the blueprint with calm-dsl*

This is usually caused by a **logic error in the blueprint code**.  You can try to compile the blueprint into a json, then import that json into Calm to see what kind of errors you are getting.

> *Windows virtual machine static IPv4 configuration is not applied correctly*

For Windows Server 2019, the subnet mask needs to be specified in bitmask format (exp: 24) while for Windows Server 2016, it needs to be specified in regular notation (exp: 255.255.255.0). Make sure you are using the right value for the subnet mask.

> *Windows virtual machine is not completing sysprep*

If you have modified the unattend.xml or changed the regex for windows hostname validation, check your unattend.xml syntax and make sure your hostname is no longer than 15 characters.