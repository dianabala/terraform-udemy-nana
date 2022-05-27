provider "google" {
  credentials = file("prod-svc-creds.json")
  project     = "stoked-dominion-348411"
  region      = "europe-central2"
  zone        = "europe-central2-a" 
}

resource "google_compute_network" "myapp-vpc" {
  name = "myapp-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "myapp-subnet-1" {
  name          = "myapp-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-central2"
  network       = google_compute_network.myapp-vpc.id
  secondary_ip_range {
    range_name    = "myapp-subnet-1-secondary-range"
    ip_cidr_range = "192.168.10.0/24"
  }
}

data "google_compute_network" "existing_vpc" {
  name = "myapp-subnet-1"
}

resource "google_compute_subnetwork" "myapp-subnet-2" {
  name          = "myapp-subnet-2"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-central2"
  network       = data.google_compute_network.existing_vpc.name
}