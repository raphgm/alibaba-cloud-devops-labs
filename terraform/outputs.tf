output "load_balancer_id" {
  value = alicloud_slb_load_balancer.public.id
}

output "load_balancer_address" {
  value = alicloud_slb_load_balancer.public.address
}

output "instance_ids" {
  value = alicloud_instance.app[*].id
}
