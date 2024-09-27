image_info=$(aws ec2 describe-images --filters Name=name,Values=default_webserver --owners self  \
--query 'Images[0].{ImageId: ImageId, SnapshotId: BlockDeviceMappings[0].Ebs.SnapshotId}')

echo $image_info

if [ "$image_info" != "null" ]; then
  image_id=$(echo $image_info | jq -r '.ImageId')
  snapshot_id=$(echo $image_info| jq -r '.SnapshotId')

  # aws ec2 deregister-image --image-id $image_id
  if [ $? -eq 0 ]; then
    echo "image $image_id deregistered"
  fi
  # aws ec2 delete-snapshot --snapshot-id $snapshot_id
  if [ $? -eq 0 ]; then
    echo "snapshot $snapshot_id deleted"
  fi
fi