//resource "github_team" "website-admins" {
//    name        = "website-admins"
//    description = "TwinDB.com admins"
//    privacy     = "closed"
//}
//
//resource "github_team_membership" "akuzminsky" {
//    team_id  = "${github_team.website-admins.id}"
//    username = "akuzminsky"
//    role     = "maintainer"
//}
//
//
//resource "github_team" "website-devs" {
//    name        = "website-devs"
//    description = "TwinDB.com developers"
//    privacy     = "secret"
//}
//
//resource "github_team_membership" "website-devs-akuzminsky" {
//    team_id  = "${github_team.website-devs.id}"
//    username = "akuzminsky"
//    role     = "maintainer"
//}
//
//resource "github_team_membership" "website-devs-mkryva" {
//    team_id  = "${github_team.website-devs.id}"
//    username = "mkryva"
//}
