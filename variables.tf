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
  type    = string
  default = ">=1.0.0"
}

variable "spec_override" {
  type    = map(any)
  default = {}
}

variable "sync_policy" {
  type         = object({
    automated  = object({
      prune    = bool
      selfHeal = bool
    })
    retry           = object({
      backoff       = object({
        duration    = string
        factor      = number
        maxDuration = string
      })
      limit   = number
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

variable "namespace" {
  type    = string
  default = "argo-cd"
}
