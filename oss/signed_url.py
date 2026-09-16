# From: "Object Storage Service (OSS) Patterns Every Alibaba Cloud Team Should Know"
# Generates a temporary, scoped-access URL instead of making a bucket public.
#
# pip install oss2
import oss2
import os

auth = oss2.Auth(os.environ["OSS_ACCESS_KEY_ID"], os.environ["OSS_ACCESS_KEY_SECRET"])
bucket = oss2.Bucket(auth, "https://oss-ap-southeast-1.aliyuncs.com", "my-bucket")

# URL valid for 10 minutes, read-only.
url = bucket.sign_url("GET", "private/report.pdf", 600)
print(url)
