import json
import os
import requests
from app import DATABASE_ID, headers


def get_pages(payload):
    url = f"https://api.notion.com/v1/databases/{DATABASE_ID}/query"
    response = requests.post(url, json=payload, headers=headers)
    return response.json()


def get_all_pages():
    data = get_pages({"page_size": 100})
    with open(os.getcwd() + "/app/files/db.json", "w", encoding="utf8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    results = data["results"]
    return results
