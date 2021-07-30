import sys

if "{{ cookiecutter.ipam_solution }}" == "solarwinds":
    """{{ cookiecutter.update(
        {
            "_phpipam_username": "sbourdeaud",
            "_phpipam_ip": "phpipam.xpert-services.eu",
            "_phpipam_app_id": "calm",
            "_phpipam_section_id": "4",
            "_infoblox_username": "calm",
            "_infoblox_ip": "infoblox.xpert-services.eu"
        }
    )}}"""

sys.exit(0)