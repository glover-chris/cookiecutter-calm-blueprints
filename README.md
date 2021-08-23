# Overview
This is  Nutanix Xpert Services Cloud and Automation Practice **cookiecutter project** offering the dynamic creation of Windows and Linux Calm blueprints with integrated IPAM solutions.

For additional details regarding cookiecutter, See
https://cookiecutter.readthedocs.io/en/latest/

Note that this repository contains exclusively content required to deploy blueprints.
All other documents (kickoff powerpoint presentation, datasheets, etc...) are stored in the [cita-starter Sharepoint folder](https://ntnx.tech/cita-starter).

This repository contains the following OS blueprints:
- **Windows** (based on Windows Server 2019)
- **Linux** (based on CentOS 7)

Each OS blueprint has the following application profiles:
- **AHV**
- **vSphere**

Each OS blueprint can have one of the following IPAM solutions added dynamically (based on the selections made when cookiecutter was run):
- **Static IP** addressing: where IPv4 configuration is captured from the user at launch time.
- **DHCP**: where IPv4 configuration is assumed to be obtained automatically.
- **IPAM-phpIPAM**: where the IPv4 configuration is drawn from a phpIPAM server instance and injected as a static IPv4 configuration in the VM.
- **IPAM-infoblox**: where the IPv4 configuration is drawn from an Infoblox IPAM server instance and injected as a static IPv4 configuration in the VM.
- **IPAM-solarwinds**: where the IPv4 configuration is drawn from a Solarwinds IPAM server instance and injected as a static IPv4 configuration in the VM.

See the [IPAMSolution-PreReqs](#IPAMSolution-PreReqs) and [Blueprint-Troubleshooting](#Blueprint-Troubleshooting) for further details.

**Note:** All scripts used in the blueprints here are maintained in the [tasklib](https://ntnx.tech/cita-tasklib) repository which is linked here as a Git Module.
## Pre-Requisite Requirements for the developer workstation

1. [Python 2.7+](https://www.python.org/downloads/)
2. [Python Package Index (PIP) 9.0.1+](https://pip.pypa.io/en/stable/installing/)
3. Python Pip Package "requests" 2.19.1+
4. Python Pip Package "pyyaml" 3.12+
5. [Install Cookiecutter](http://cookiecutter.readthedocs.io/en/latest/installation.html#install-cookiecutter)
6. [Install Calm-Dsl](https://github.com/nutanix/calm-dsl)

## Pre-Requisite Requirements for the Calm instance where blueprints will be deployed

1. **Enable Calm** in the client Prism Central
2. **Configure** AHV and vSphere **providers** in Calm (either or both depending on the client requirements)
3. **Create** a **Calm project** which is authorized for AHV and vSphere clusters/providers and has default environments configured for Windows and Linux on each provider

#### Cookiecutter will ask for the following data to be entered so you will need to determine the values ahead of time (Default values can be selected but may not function properly when the blueprints are created on the Calm instance):
   1. **AHV information**:
	- Name of the **Windows** Server 2019 **template** disk image (which must be sysprep ready)
	- Name of the **CentOS 7** cloud **disk image** (which must be cloud-init ready)
	- Name of the default **AHV network** to use for Windows and Linux VMs
    - Name of the **AHV cluster** to deploy to
   1. **vSphere information**:
	- Id of the vCenter **VM template for Windows** Server 2019 (does not need to be sysprep ready)
	- Id of the vCenter **VM template for CentOS7** (which must be cloud-init ready and NOT have any cdrom drive as one will be added automatically during provisioning)
	- Name of the **vCenter datacenter**, HA/DRS cluster and **datastore** cluster to use
	- Name of the **network portgroup** to use for Windows and Linux VMs
   1. **Additional information**:
    - Name of the **Active Directory domain** to use for Windows VMs
	- If you are using static IP addresses, the **IPv4 configuration** information: subnet mask, default gateway and DNS servers to use
	- **SMTP gateway IP** address and default **sender email** address for email notifications

## Usage

1. From a working directory of your choice, run the following command and respond to prompts.

    `cookiecutter https://github.com/nutanixservices/cookiecutter-calm-ipam-blueprints --checkout main -f`

    `--checkout main`  will make sure you are running latest stable version.

    It will ask you questions about options for the blueprint you wish to create like the IPAM solution you want to use,
    the folder name where you want to blueprints created, e.g., blueprints-ipam-infoblox, amount of RAM for the VM, etc...  You can jump to the next question by entering an empty string which will use the default value in the `cookiecutter.json`.  See [Example](#example) below.

	##### Note - Multiple Calm Environments can be used
   - For the `calm_environment` selection, any string value is fine but it is recommended to enter something useful to describe the calm instance to which you will connect as you can later have multiple sites configured by running `make init-dsl` another time, after the initial cookiecutter selections, and supplying a new value for `calm_environment`, e.g., `make init-dsl CALM_ENVIRONMENT=site2 CALM_PROJECT=default PC_IP_ADDRESS=site2IP`.  The default values for `calm_environment`, `prism_central_ip_address` and `calm_project` will be what was selected during the initial cookiecutter and can be overridden during make commands to switch to other Calm/PC instances.

2. Navigate into newly created directory.

    `cd blueprints_folder_name/`

3. Run `make help` to review the various options that can be executed via make commands.
```
create-all-bps                 Create all blueprints on the Calm instance.
create-linux-ipam-bp           Create Linux IPAM blueprint on Calm instance.
create-windows-ipam-bp         Create Linux IPAM blueprint on Calm instance.
delete-all-bps                 Delete all blueprints from the Calm instance.
delete-linux-ipam-bp           Delete the Linux IPAM blueprint from the Calm instance.
delete-windows-ipam-bp         Delete the Linux IPAM blueprint from the Calm instance.
init-dsl-config                Init Calm-Dsl to the Calm instance entered during the cookiecutter run.
init-dsl-secrets               Create local Calm-Dsl and Blueprint secrets.
init-dsl                       Create local Calm-Dsl and Blueprint secrets.  Then init Calm-Dsl to the Calm instance entered during the cookiecutter run.
```
6. **Create the DSL and blueprint secrets as well as initialize Calm DSL with the Calm instance entered in Cookiecutter** by running `make init-dsl`.  This will add credential files in a `.local` folder at the root of the newly created directory to enable blueprint compiling and initializing Calm DSL.  Supply your username and password for the Calm instance IP that you entered during the initial cookiecutter run.
   **Note:** The `dsl-init-secrets.sh` file, which is called from the Make command, can be edited to include proper blueprint passwords as needed.
  Information on initializing to more than one Calm site is located here [Multiple Calm Environments can be used](#Note---Multiple-Calm-Environments-can-be-used).
7.  **Create the Cookiecutter blueprints on the Calm instances by running one of the make create blocks, e.g., `make create-linux-ipam-bp` or `make create-windows-ipam-bp` or `make create-all-bps`**
8.  **Delete the blueprints from the Calm instance by running one of the make delete blocks, f.g., `make delete-linux-ipam-bp` or `make delete-windows-ipam-bp` or `make delete-all-bps`**
9.  **Customize the blueprints** as required by the client.
10. Use calm-dsl to **compile each blueprint** the client requires.
11. **Test** each blueprint.
12. **Publish** each blueprint in the Calm marketplace.

The sections below will provide detailed instructions for each one of those steps.
If this is the first time you use a Cloud & Automation Calm repository, you will want to read the following documents first:
- Setting up a workstation for calm-dsl based development
- Understanding the structure of calm-dsl decompiled blueprints

# IPAMSolution-PreReqs
## phpipam
1. In phpIPAM > Server Management > phpIPAM Settings > Feature Settings > API must be turned **ON** (default is **OFF**)
2. Create an application in phpIPAM > Server Management > API (use "SSL with user token" for security and "read/write" for access; make a note of the app id)
## infoblox
1. The default gateway and dns servers have been defined on the network
## solarwinds
1. A Calm endpoint called solarwinds has been defined with the proper credentials in Calm that points to the SolarWinds IPAM Windows server
2. Remote PowerShell has been configured and enabled on the SolarWinds IPAM Windows server
# Blueprint-Troubleshooting

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