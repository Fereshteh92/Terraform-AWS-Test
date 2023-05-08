variable "iam_profile_name" {
  description = "name of the instant iam profile"
  type        = list(string)
  default     = ["web_server_iam_profile", "api_server_iam_profile"]
}