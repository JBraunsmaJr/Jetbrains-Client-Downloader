import os
import sys

import requests
import argparse
import subprocess

URL: str = "https://data.services.jetbrains.com/products?code={product_codes}"
DOWNLOAD_DIR="/home/user/clients"
OUTPUT_DIR="/home/user/output"

class Product:
    def __init__(self, product_code: str, version: str):
        self.product_code = product_code
        self.version = version
        self.build_number: str | None = None
    def __str__(self):
        return f"""
-----------------------------------
Product: {self.product_code}
Version: {self.version}
Build Number: {self.build_number}
-----------------------------------
"""

OUTPUT_FILE = "clients.tar.gz"

def parse_args() -> list[Product]:
    parser = argparse.ArgumentParser()
    parser.add_argument("--filename",
                        dest="filename",
                        required=False,
                        default=None
                        )

    parser.add_argument("--product",
                        dest="product_codes",
                        required=True,
                        help="Product code(s) to download",
                        nargs="+")
    args = parser.parse_args()

    if args.filename is not None:
        global OUTPUT_FILE
        OUTPUT_FILE = args.filename

    products: list[Product] = []
    for arg in args.product_codes:
        if "=" in arg:
            products.append(Product(*arg.split("=")))
        else:
            products.append(Product(arg, "latest"))
    return products

def get_data_by_code(data: list[dict], code: str) -> dict | None:
    for product in data:
        if product["code"] == code or product["intellijProductCode"] == code:
            return product
    return None

def fetch_product_data(products: list[Product]):
    codes = ",".join([x.product_code for x in products])
    response = requests.get(URL.format(product_codes=codes))
    product_data = response.json()

    for product in products:
        current_product_data = get_data_by_code(product_data, product.product_code)

        if not current_product_data:
            raise LookupError(f"Product code {product.product_code} not found")

        if product.version == "latest":
            for release in current_product_data["releases"]:
                if release["type"] != "release":
                    continue
                product.build_number = release["build"]
                break
            if product.build_number is None:
                raise LookupError(f"Product code {product.product_code} has no releases")
        else:
            for release in current_product_data["releases"]:
                if release["type"] != "release":
                    continue
                if release["build"] == product.version or release["version"] == product.version:
                    product.build_number = release["build"]
                    break

if __name__ == "__main__":
    search_products = parse_args()
    fetch_product_data(search_products)
    for product in search_products:

        print(product)

        result = subprocess.run(
            " ".join(["/home/user/download.sh", product.product_code, product.build_number]),
            check=False,
            capture_output=True,
            shell=True
        )

        if result.returncode != 0:
            print(result.stdout.strip().decode("utf-8"), file=sys.stdout)
            print(result.stderr.strip().decode("utf-8"), file=sys.stderr)
            raise RuntimeError("Download failed")

    os.system(f"tar -cvf \"{OUTPUT_DIR}/{OUTPUT_FILE}\" -C \"{DOWNLOAD_DIR}\" .")
