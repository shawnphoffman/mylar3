FROM python:3.12-slim

LABEL org.opencontainers.image.source="https://github.com/shawnphoffman/mylar3"
LABEL org.opencontainers.image.description="Mylar3 - automated comic book manager (personal fork build)"

# Runtime system packages:
#  - git: used by Mylar's version check to read the current commit
#  - unrar-free / p7zip: archive handling for cbr/cbz post-processing
#  - libjpeg/zlib: Pillow runtime deps
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        unrar-free \
        p7zip-full \
        libjpeg62-turbo \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/mylar

# Install Python deps first so this layer caches across source changes.
COPY requirements.txt ./
RUN pip install --no-cache-dir -U -r requirements.txt

# Copy the local fork source (so personal changes are baked into the image).
COPY . .

# ports and volumes
VOLUME /config /comics /downloads
EXPOSE 8090

CMD ["python3", "/app/mylar/Mylar.py", "--nolaunch", "--quiet", "--datadir", "/config/mylar"]
