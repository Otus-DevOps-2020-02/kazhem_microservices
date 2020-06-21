terraform {
  backend "gcs" {
    bucket = "kazhemm-otus-tf-storage"
    prefix = "terraform/state/stage"
  }
}
