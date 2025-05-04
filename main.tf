# Copyright 2024 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Future versions of the script may add modularity if it is needed, though the intent of the script is to be simple and have limited configurability.


data "google_compute_network" "vpc1" {
  project = var.project-id
  name = var.vpc1name
}

data "google_compute_network" "vpc2" {
  project = var.project-id
  name = var.vpc2name
}

# VPNGW, tunnels and CR from vpc1 to vpc2
module "vpn-1" {
  source         = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpn-ha?ref=v28.0.0"  
  project_id = var.project-id
  region     = var.region1
  network    = data.google_compute_network.vpc1.self_link
  name       = "vpngw-${data.google_compute_network.vpc1.name}"
  peer_gateways = {
    default = { gcp = module.vpn-2.self_link }
  }
  router_config = {
    asn = 64514
    name = "cldrtr-${data.google_compute_network.vpc1.name}-${var.region1}-internal"
    custom_advertise = {
      all_subnets = true
      ip_ranges = {
        "10.0.0.0/8" = "default"
      }
    }
  }
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.1.2/30"
      vpn_gateway_interface = 0
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64513
      }
      bgp_session_range     = "169.254.2.2/30"
      vpn_gateway_interface = 1
    }
  }
}

# VPNGW, tunnels and CR from vpc2 to vpc1
module "vpn-2" {
  source         = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/net-vpn-ha?ref=v28.0.0"  
  project_id = var.project-id
  region        = var.region1
  network    = data.google_compute_network.vpc2.self_link
  name       = "vpngw-${data.google_compute_network.vpc2.name}"
  router_config = { 
    asn = 64513 
    name = "cldrtr-${data.google_compute_network.vpc2.name}-${var.region1}-internal"
    custom_advertise = {
      all_subnets = true
      ip_ranges = {
      }
    }
  }
  peer_gateways = {
    default = { gcp = module.vpn-1.self_link }
  }
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.1.1/30"
      shared_secret         = module.vpn-1.random_secret
      vpn_gateway_interface = 0
    }
    remote-1 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64514
      }
      bgp_session_range     = "169.254.2.1/30"
      shared_secret         = module.vpn-1.random_secret
      vpn_gateway_interface = 1
    }
  }
}
