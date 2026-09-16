# From: "Object Storage Service (OSS) Patterns Every Alibaba Cloud Team Should Know"
# Multipart upload for files over 100MB — failed parts retry independently.
#
# pip install oss2
import os
import oss2

auth = oss2.Auth(os.environ["OSS_ACCESS_KEY_ID"], os.environ["OSS_ACCESS_KEY_SECRET"])
bucket = oss2.Bucket(auth, "https://oss-ap-southeast-1.aliyuncs.com", "my-bucket")


def split_file(path, part_size):
    with open(path, "rb") as f:
        while chunk := f.read(part_size):
            yield chunk


def upload(file_path, key):
    upload_id = bucket.init_multipart_upload(key).upload_id
    parts = []
    for i, chunk in enumerate(split_file(file_path, part_size=10 * 1024 * 1024)):
        result = bucket.upload_part(key, upload_id, i + 1, chunk)
        parts.append(oss2.models.PartInfo(i + 1, result.etag))
    bucket.complete_multipart_upload(key, upload_id, parts)


if __name__ == "__main__":
    upload("large-file.zip", "large-file.zip")
