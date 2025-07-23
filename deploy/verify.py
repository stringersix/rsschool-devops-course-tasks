import requests

def verify_url(url):
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        print("Success! Response:")
        print(response.text)
        return 0
    except requests.RequestException as e:
        print(f"Failed to connect to {url}: {e}")
        return 1