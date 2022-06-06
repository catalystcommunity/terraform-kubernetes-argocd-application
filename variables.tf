# required
variable "name" {
  description = "Name of the ArgoCD application custom resource"
  type        = string
}

variable "source_chart" {
  description = "Name of Helm chart"
  type        = string
}

variable "source_repo_url" {
  description = "Helm repository URL"
  type        = string
}

# optional
variable "helm_values" {
  description = "Helm values as a raw string in YAML format"
  type        = string
  default     = ""
}

variable "source_target_revision" {
  description = "Target revision of the helm chart"
  type        = string
  default     = ">=1.0.0"
}

variable "spec_override" {
  description = "Application spec override. Gets merged with the default applcation spec that's generated from existing variables. Allows specifying configuration that is not specifically implemented by this module."
  type        = map(any)
  default     = {}
}

variable "sync_policy" {
  description = "ArgoCD application sync policy. Defaults to a frequent automatic sync."
  type = object({
    automated = object({
      prune    = bool
      selfHeal = bool
    })
    retry = object({
      backoff = object({
        duration    = string
        factor      = number
        maxDuration = string
      })
      limit = number
    })
    syncOptions = list(string)
  })
  default = {
    "automated" = {
      "prune"    = true
      "selfHeal" = true
    }
    "retry" = {
      "backoff" = {
        "duration"    = "5s"
        "factor"      = 2
        "maxDuration" = "3m"
      }
      "limit" = 3
    }
    "syncOptions" = [
      "CreateNamespace=true",
      "PrunePropagationPolicy=foreground",
      "PruneLast=true",
    ]
  }
}

variable "project" {
  description = "ArgoCD project to associate the application to"
  type        = string
  default     = "default"
}

variable "namespace" {
  description = "Namespace to deploy the ArgoCD application custom resource. Should be in the same namespace as ArgoCD."
  type        = string
  default     = "argo-cd"
}
