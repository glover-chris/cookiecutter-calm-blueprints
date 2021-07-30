# region headers
"""
# escript-template v20190611 / stephane.bourdeaud@nutanix.com
# * author:     stephane.bourdeaud@nutanix.com
# * version:    2020/10/16, v1
# task_name:    InfobloxGetOptions
# description:  Given a network, get the DNS and default gateway options.
# input:        network (exp: 192.168.0.0/24)
# output:       dns, default_gateway
"""
# endregion

# region capture Calm variables
# * Capture variables here. This makes sure Calm macros are not referenced
# * anywhere else in order to improve maintainability.
username = '@@{infoblox.username}@@'
username_secret = "@@{infoblox.secret}@@"
api_server = "@@{infoblox_ip}@@"
network = "@@{network}@@"
# endregion

# region prepare variables
api_server_port = "443"
secure_calls=True
# endregion

# region API call function
import requests

def process_request(url, method, user, password, headers, payload=None, secure=secure_calls):
    """
    Processes a web request and handles result appropriately with retries.
    Returns the content of the web request if successfull.
    """
    if payload is not None:
        payload = json.dumps(payload)

    #configuring web request behavior
    timeout=10
    retries = 5
    sleep_between_retries = 5

    while retries > 0:
        try:

            if method is 'GET':
                response = requests.get(
                    url,
                    headers=headers,
                    auth=(user, password),
                    verify=secure,
                    timeout=timeout
                )
            elif method is 'POST':
                response = requests.post(
                    url,
                    headers=headers,
                    data=payload,
                    auth=(user, password),
                    verify=secure,
                    timeout=timeout
                )
            elif method is 'PUT':
                response = requests.put(
                    url,
                    headers=headers,
                    data=payload,
                    auth=(user, password),
                    verify=secure,
                    timeout=timeout
                )
            elif method is 'PATCH':
                response = requests.patch(
                    url,
                    headers=headers,
                    data=payload,
                    auth=(user, password),
                    verify=secure,
                    timeout=timeout
                )
            elif method is 'DELETE':
                response = requests.delete(
                    url,
                    headers=headers,
                    data=payload,
                    auth=(user, password),
                    verify=secure,
                    timeout=timeout
                )

        except requests.exceptions.HTTPError as error_code:
            print ("Http Error!")
            print("status code: {}".format(response.status_code))
            print("reason: {}".format(response.reason))
            print("text: {}".format(response.text))
            print("elapsed: {}".format(response.elapsed))
            print("headers: {}".format(response.headers))
            if payload is not None:
                print("payload: {}".format(payload))
            print(json.dumps(
                json.loads(response.content),
                indent=4
            ))
            exit(response.status_code)
        except requests.exceptions.ConnectionError as error_code:
            print ("Connection Error!")
            if retries == 1:
                print('Error: {c}, Message: {m}'.format(c = type(error_code).__name__, m = str(error_code)))
                exit(1)
            else:
                print('Error: {c}, Message: {m}'.format(c = type(error_code).__name__, m = str(error_code)))
                sleep(sleep_between_retries)
                retries -= 1
                print ("retries left: {}".format(retries))
                continue
            print('Error: {c}, Message: {m}'.format(c = type(error_code).__name__, m = str(error_code)))
            exit(1)
        except requests.exceptions.Timeout as error_code:
            print ("Timeout Error!")
            if retries == 1:
                print('Error: {c}, Message: {m}'.format(c = type(error_code).__name__, m = str(error_code)))
                exit(1)
            print('Error! Code: {c}, Message: {m}'.format(c = type(error_code).__name__, m = str(error_code)))
            sleep(sleep_between_retries)
            retries -= 1
            print ("retries left: {}".format(retries))
            continue
        except requests.exceptions.RequestException as error_code:
            print ("Error!")
            exit(response.status_code)
        break

    if response.ok:
        return response
    if response.status_code == 401:
        print("status code: {0}".format(response.status_code))
        print("reason: {0}".format(response.reason))
        exit(response.status_code)
    elif response.status_code == 500:
        print("status code: {0}".format(response.status_code))
        print("reason: {0}".format(response.reason))
        print("text: {0}".format(response.text))
        exit(response.status_code)
    else:
        print("Request failed!")
        print("status code: {0}".format(response.status_code))
        print("reason: {0}".format(response.reason))
        print("text: {0}".format(response.text))
        print("raise_for_status: {0}".format(response.raise_for_status()))
        print("elapsed: {0}".format(response.elapsed))
        print("headers: {0}".format(response.headers))
        if payload is not None:
            print("payload: {0}".format(payload))
        print(json.dumps(
            json.loads(response.content),
            indent=4
        ))
        exit(response.status_code)

# endregion

# region get network options
# ! You may have to change the endpoint based on your Infoblox version
api_server_endpoint = "/wapi/v2.7.1/network?network={}&_return_fields=options".format(network)
base_url = "https://{}:{}{}".format(
    api_server,
    api_server_port,
    api_server_endpoint
)
headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
}
url=base_url
method = "GET"

dns=""
default_gateway=""

print("Making a {} API call to {}".format(method, url))
resp = process_request(url, method, username, username_secret, headers)
if resp.ok:
    print("Request was successful. Processing results...")
    #print('Response: {}'.format(json.dumps(json.loads(resp.content), indent=4)))
    for option in json.loads(resp.content)[0]['options']:
        if option['name'] == 'domain-name-servers':
            dns_servers = option['value']
            dns_servers = dns_servers.split(',')
        if option['name'] == 'routers':
            default_gateway = option['value']
else:
    exit(1)

if dns_servers:
    print("dns1= {}".format(dns_servers[0]))
    print("dns2= {}".format(dns_servers[1]))
else:
    print("No domain name server option found in network {}".format(network))
    exit(1)

if default_gateway:
    print("gateway={}".format(default_gateway))
else:
    print("No router option found in network {}".format(network))
    exit(1)

# endregion