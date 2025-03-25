terraform {
  required_providers {
    
    google = {
      source = "hashicorp/google"
      version = "~> 5.10.0"
    }
  }

  backend "gcs" {}
}

# Configure the Google Cloud provider
provider "google" {
  project = "red-hat-mbu"
  region  = "us-east1"
  zone    = "us-east1-b"
}

# Create the VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "gcvm-tf-instance"
  machine_type = "e2-small"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "projects/rhel-cloud/global/images/rhel-9-v20250311"
      size  = 40
    }
  }

  network_interface {
    subnetwork = "projects/red-hat-mbu/regions/us-east1/subnetworks/instancenet"
  }
}

# Output the VM's internal IP
output "vm_internal_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].network_ip
}

## Output the VM's public IP
# output "vm_public_ip" {
#   value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
# }
