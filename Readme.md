# Remote Dev

**Links**

[Jetbrains - fully offline mode](https://www.jetbrains.com/help/idea/fully-offline-mode.html)

[Jetbrains - Product codes](https://plugins.jetbrains.com/docs/marketplace/product-codes.html)

## Example

```bash
docker run --rm -e PRODUCT_CODE=PY -e BUILD_VERSION=252.25557.178 -e FILENAME=pycharm-clients.tar.gz -v ./output:/home/user/output mercenary9312/jetbrains-clients-downloader
```

With docker compose, you can leverage a `.env` file with the variables defined. Otherwise, the default example values will be used.
```bash
docker compose up
```

## Overview

The `pull-remote.sh` script isolates a single product and build number to keep the tarball size small.

Assumption made here is why collect all builds? If in an environment that does not have direct public internet access - you're likely going to need only 1 version until a newer version comes out that's worth upgrading to. (Not saying upgrading isn't worth it, just depends on how much of a pain it is to move things into said environment).

## How to get build version

- You can query the following, using product code, to obtain a list of build numbers. `https://data.services.jetbrains.com/products?code=PRODUCT_CODE_GOES_HERE`

- You can alternatively open up the IDE you already have installed and open `Help` -> `About` (bottom left - at least in Rider when you're prompted for which project you want to open).

![about](./images/helpmodal.png)


- You can also use Jetbrain's toolbox app. If not installed, an arrow will appear - click on it and you can checkout the versions.

![notinstalled](./images/notinstalled.png)
![versions](./images/toolbox-versions.png)


- If you already have an IDE installed, you can click on the 3 dots and look at the about section.

![installed](./images/installed.png)

