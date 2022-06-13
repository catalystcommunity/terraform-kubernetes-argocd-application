# terraform-kubernetes-argocd-application

This module deploys an ArgoCD application custom resource. It utilizes the
[kubectl provider](https://github.com/gavinbunney/terraform-provider-kubectl)
instead of the official Kubernetes provider to mitigate common problems with
custom resources in Terraform, such as:
* Required API access during planning time, requiring multiple terraform states
  in order to deploy an application to Kubernetes.
* Sensitive values are displayed in logs, 
  [ref](https://github.com/hashicorp/terraform-provider-kubernetes/issues/1728).

## Example Implementations

### Basic

You can make use of the built-in [templatefile()](https://www.terraform.io/language/functions/templatefile)
function to easily add secret values to the platform_services_values if secret
configuration is required.
```terraform
provider "kubectl" {
  # provider configuration ...
}

module "my_app" {
  source = "catalystsquad/argocd-application/kubernetes"

  name            = "my-app"
  source_chart    = "my-app"
  source_repo_url = "https://example.com/repository"
  helm_values     = templatefile("./helm-values/my-application-values.yaml", {
    "exampleSecretInput" : var.example_secret
  })
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the ArgoCD application custom resource | `string` | n/a | yes |
| <a name="input_source_chart"></a> [source\_chart](#input\_source\_chart) | Name of Helm chart | `string` | n/a | yes |
| <a name="input_source_repo_url"></a> [source\_repo\_url](#input\_source\_repo\_url) | Helm repository URL | `string` | n/a | yes |
| <a name="input_helm_values"></a> [helm\_values](#input\_helm\_values) | Helm values as a raw string in YAML format | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace to deploy the ArgoCD application custom resource. Should be in the same namespace as ArgoCD. | `string` | `"argo-cd"` | no |
| <a name="input_project"></a> [project](#input\_project) | ArgoCD project to associate the application to | `string` | `"default"` | no |
| <a name="input_source_target_revision"></a> [source\_target\_revision](#input\_source\_target\_revision) | Target revision of the helm chart | `string` | `">=1.0.0"` | no |
| <a name="input_spec_override"></a> [spec\_override](#input\_spec\_override) | Application spec override. Gets merged with the default applcation spec that's generated from existing variables. Allows specifying configuration that is not specifically implemented by this module. | `map(any)` | `{}` | no |
| <a name="input_sync_policy"></a> [sync\_policy](#input\_sync\_policy) | ArgoCD application sync policy. Defaults to a frequent automatic sync. | <pre>object({<br>    automated = object({<br>      prune    = bool<br>      selfHeal = bool<br>    })<br>    retry = object({<br>      backoff = object({<br>        duration    = string<br>        factor      = number<br>        maxDuration = string<br>      })<br>      limit = number<br>    })<br>    syncOptions = list(string)<br>  })</pre> | <pre>{<br>  "automated": {<br>    "prune": true,<br>    "selfHeal": true<br>  },<br>  "retry": {<br>    "backoff": {<br>      "duration": "5s",<br>      "factor": 2,<br>      "maxDuration": "3m"<br>    },<br>    "limit": 3<br>  },<br>  "syncOptions": [<br>    "CreateNamespace=true",<br>    "PrunePropagationPolicy=foreground",<br>    "PruneLast=true"<br>  ]<br>}</pre> | no |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.application](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |

## Modules

No modules.
<!-- END_TF_DOCS -->
