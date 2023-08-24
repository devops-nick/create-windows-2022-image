locals {
  group     = "GIG"
  division  = "CISS"
  platform  = "CloudLabs"
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}