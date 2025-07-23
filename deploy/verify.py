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

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python verify.py <url>")
        sys.exit(1)
    url = sys.argv[1]
    exit_code = verify_url(url)
    sys.exit(exit_code)