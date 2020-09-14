resource "ibm_resource_instance" "iac_app_cos_instance" {
  name     = "${var.project_name}-${var.environment}-cos-instance"
  resource_group_id = data.ibm_resource_group.group.id
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}

resource "ibm_cos_bucket" "iac_app_cos_bucket" {
  bucket_name          = "${var.project_name}-${var.environment}-bucket"
  resource_instance_id = ibm_resource_instance.iac_app_cos_instance.id
  region_location      = "us-south"
  storage_class        = "smart"
}

resource "ibm_is_volume" "iac_app_volume" {
  count    = local.max_size
  name     = "${var.project_name}-${var.environment}-volume-${format("%02s", count.index)}"
  profile  = "10iops-tier"
  zone     = var.vpc_zone_names[count.index]
  capacity = 100
}
