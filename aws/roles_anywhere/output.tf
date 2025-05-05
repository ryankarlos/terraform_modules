

output "trust_anchor_arn" {
  value = aws_rolesanywhere_trust_anchor.trust_anchor.arn
}

output "roles_anywhere_profile_arn" {
  value = aws_rolesanywhere_profile.demo_profile.arn
}


output "role_arn" {
  value = aws_iam_role.roles_anywhere_role.arn

}
