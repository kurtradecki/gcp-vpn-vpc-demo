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


# Add values for these 4 variables
  project-id = "ADD PROJECT ID HERE"
  region1 = "ADD REGION HERE"
  vpc1name = "ADD 1ST VPC NAME HERE"
  vpc2name = "ADD 2ND VPC NAME HERE"

# Change below this line if you need to customize the routing
  vpc1_cldrouter_custom = {
    all_subnets = true  # change to false as needed
    ip_ranges   = {
      "10.0.0.0/8" = "10 range"  # add more as needed by adding a comman and then another "" = "" with values
    }
  }

  vpc2_cldrouter_custom =  {
    all_subnets = true  # change to false as needed
    ip_ranges   = {
      "172.16.0.0/12" = "172.16 range", 
      "192.168.0.0/16" = "192.168 range"  # add more as needed by adding a comman and then another "" = "" with values
    }
  }