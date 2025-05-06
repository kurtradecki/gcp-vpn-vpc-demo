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


variable  project-id {}
variable  region1 {}
variable  vpc1name {}
variable  vpc2name {}
variable vpc1_cldrouter_config {
  type = object({
      all_subnets = bool
      ip_ranges   = map(string)
    })
}
variable vpc2_cldrouter_config {
  type = object({
      all_subnets = bool
      ip_ranges   = map(string)
    })
}
