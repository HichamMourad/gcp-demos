terraform {
  required_providers {
    
    google = {
      source = "hashicorp/google"
      version = "6.26.0"
    }
  }

  backend "s3" {}
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
    network = "network-instance"
  }

# Output the VM's public IP
output "vm_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}