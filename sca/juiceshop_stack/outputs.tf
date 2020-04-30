output "juiceshop_aws_names" {
    value = [
        for id, instance in aws_instance.appnode:
          instance.tags.Name
    ]
}